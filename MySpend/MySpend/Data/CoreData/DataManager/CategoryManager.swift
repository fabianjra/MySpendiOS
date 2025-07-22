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
    func fetchAll(predicateFormat: String = CDConstants.Predicate.byIsActive,
                            predicateArgs: [Any] = [true],
                            sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) async throws -> [CategoryModel] {

        try await viewContext.perform {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
            
            let coreDataEntities = try viewContext.fetch(request)
            
            let models = coreDataEntities.map { entity in
                CategoryModel(entity)
            }
            
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
        
        guard let entity = try await CategoryManager.fetch(model, viewContextArg: viewContext) else {
            throw CDError.notFoundUpdate(entity: Category.description())
        }
        
        try await viewContext.perform {
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
        
        guard let entity = try await CategoryManager.fetch(model, viewContextArg: viewContext) else {
            throw CDError.notFoundUpdate(entity: Category.description())
        }
        
        try await viewContext.perform {
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
     Fetches the `Category` entity whose primary key matches `model.id`.
     
     Internally:
     1. Builds an `NSFetchRequest<Category>` via `CoreDataUtilities.createFetchRequest(ByID:entity:)`, using the model’s UUID string.
     2. Executes the request in `viewContextArg`.
     3. Logs a `.notFound` message and returns `nil` when no matching object is found; otherwise returns the first (and only) result.
     
     - Parameters:
        - model: `CategoryModel` whose `id` is used as the lookup key.
        - viewContextArg: The managed-object context that executes the fetch.
     
     - Returns: The matching `Category` entity, or `nil` if none exists.
     - Throws: Any error thrown by `viewContextArg.fetch(_:)`.
     - Date: Jul 2025
     */
    static func fetch(_ model: CategoryModel, viewContextArg: NSManagedObjectContext) async throws -> Category? {
        
        try await viewContextArg.perform {
            
            let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Category.self)
            let entity = try viewContextArg.fetch(fetchRequest)
            
            guard let item = entity.first else {
                Logger.custom(CDError.notFoundFetch(entity: Category.description()).localizedDescription)
                return nil
            }
            
            return item
        }
    }
    
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
    static func resolve(from model: CategoryModel, viewContextArg: NSManagedObjectContext) async throws -> Category {
        if let existing = try await CategoryManager.fetch(model, viewContextArg: viewContextArg) {
            return existing
        }
        
        let entity = CoreDataUtilities.createCategoryEntity(from: model, viewContext: viewContextArg)
        return entity
    }
}
