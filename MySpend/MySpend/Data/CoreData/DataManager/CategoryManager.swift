//
//  CategoryManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/25.
//

import CoreData

/**
 `CategoryManager` is responsible for managing Core Data storage and handling all data-related operations throughout the app.
 It serves as a bridge between Core Data and the user interface.

 - Authors: Fabian Rodriguez
 - Version: 1.0
 */
struct CategoryManager {
    
    // El ViewContext es lo que se va a modificar.
    // Cuando se agreguen nuevos datos a Core Data, se debe obtener el ViewContext para hacerlo.
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    private typealias predicate = CDConstants.Predicate
    
    // MARK: READ
    
    /**
     Fetch `Category` objects matching a predicate, sort them, and return the results as `[CategoryModel]`.
     
      ### Example
      ```swift
      // 1. Uso por defecto (solo categorías activas ordenadas por nombre)
      let categories = try manager.fetchAll()
     
      // 2. Filtro combinado y orden personalizado
      let predicate = "isActive == %@ AND type == %@"
      let args: [Any] = [true, CategoryType.expense.rawValue]
      let order = [
          NSSortDescriptor(keyPath: \Category.name, ascending: true),
          NSSortDescriptor(keyPath: \Category.dateCreated, ascending: false)
      ]
     
      let expenseCategories = try manager.fetchAll(
          predicateFormat: predicate,
          predicateArgs: args,
          sortedBy: order
      )
      ```
     
     - Parameters:
       - predicateFormat: NSPredicate format string (default `"isActive == %@"`).
       - predicateArgs: Arguments for the predicate (default `[true]`).
       - sortDescriptors: Sorting criteria (default by `name` ascending).
     
     - Returns: An array of `CategoryModel`.
     - Throws: Propagates any Core Data fetch errors.
     */
    func fetchAll(predicateFormat: String = predicate.byIsActive,
                            predicateArgs: [Any] = [true],
                            sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) async throws -> [CategoryModel] {

        try await viewContext.perform {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
            
            let coreDataEntities = try viewContext.fetch(request)
            
            let models = coreDataEntities.map { CategoryModel($0) }
            
            return models
        }
    }

    
    // MARK: CREATE / UPDATE
    
    /**
     Create and persist a new Core Data `Category` from a `CategoryModel`.
    
     - Parameters:
        - model: Source model with the data to store.
     
     - Throws: Any error thrown by `viewContext.save()`.
     */
    func create(_ model: CategoryModel) async throws {
        
        // garantía de thread-safety
        try await viewContext.perform {
            
            // Se crea un nuevo objeto "Entity" para mapear los campos que se van a guardar en la Entidad de Note.
            // Se debe utilizar el contexto que ya está instanciado.
            let entity = Category(context: viewContext)
            
            // Shared attributes (Abstract class):
            entity.dateCreated = .now
            entity.dateModified = .now
            entity.id = model.id
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.dateLastUsed = .now
            entity.icon = model.icon
            entity.name = model.name
            entity.type = model.type.rawValue
            entity.usageCount = .zero
            
            try viewContext.save()
        }
    }
    
    /**
     Update an existing `Category` with values from a `CategoryModel`.
    
     - Parameters;
        - model: Model containing the new values.
     
     - Throws: `.notFound` (from `fetchedCategory`) or any Core Data save error.
     */
    func update(_ model: CategoryModel) async throws {
        try await viewContext.perform {
            guard let entity = try CoreDataUtilities.fetch(byID: model.id.uuidString,
                                                           entity: Category.self,
                                                           viewContextArg: viewContext) else {
                throw CDError.notFoundUpdate(entity: Category.entityName)
            }
            
            // Shared attributes (Abstract class):
            entity.dateModified = .now
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.icon = model.icon
            entity.name = model.name
            entity.type = model.type.rawValue
            
            try viewContext.save()
        }
    }
    
    
    // MARK: DELETE
    
    func delete(_ model: CategoryModel) async throws {
        try await viewContext.perform {
            guard let entity = try CoreDataUtilities.fetch(byID: model.id.uuidString,
                                                           entity: Category.self,
                                                           viewContextArg: viewContext) else {
                throw CDError.notFoundUpdate(entity: Category.entityName)
            }
            
            viewContext.delete(entity)
            try viewContext.save()
        }
    }
    
    func delete(at offsets: IndexSet, from items: [CategoryModel]) async throws {
        for offset in offsets {
            let model = items[offset]
            try await delete(model)
        }
    }
    
    
    // MARK: SHARED

    /**
     Returns the `Category` Core Data entity matching the given `CategoryModel`,
     Creating and inserting a new one when none is found.
     
     Workflow:
     1. Calls `CategoryManager.fetch(_:viewContextArg:)` to look up an existing `Category` whose **id** matches `model.id`.
     2. If the entity exists, it is returned as-is.
     3. If no match is found, a brand-new `Category` is created via
     `CoreDataUtilities.createCategoryEntity(from:viewContext:)` and returned.
     
     - Parameters:
        - model: The `CategoryModel` containing the identifier and field values to search for—or to seed a new entity with.
        - viewContextArg: The `NSManagedObjectContext` in which the lookup/insertion is performed.
     
     - Returns: A managed `Category` object residing in `viewContextArg`.
     - Throws: Rethrows any error raised by `CategoryManager.fetch`.
     - Date: Jul 2025
     */
    static func resolve(from model: CategoryModel, viewContextArg: NSManagedObjectContext) throws -> Category {
        if let entity = try CoreDataUtilities.fetch(byID: model.id.uuidString,
                                                    entity: Category.self,
                                                    viewContextArg: viewContextArg) {
            return entity
        }
        
        let entity = CoreDataUtilities.createCategoryEntity(from: model, viewContext: viewContextArg)
        return entity
    }
}
