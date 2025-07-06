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
    func fetchAll(predicateFormat: String = CDConstants.Predicates.isActive,
                            predicateArgs: [Any] = [true],
                            sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) throws -> [CategoryModel] {

        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        
        let coreDataEntities = try viewContext.fetch(request)
        
        let models = coreDataEntities.map { entity in
            CategoryModel(entity)
        }
        
        return models
    }

    
    // MARK: CREATE / UPDATE
    
    /**
     Create and persist a new Core Data `Category` from a `CategoryModel`.
    
     - Parameters:
        - model: Source model with the data to store.
     
     - Throws: Any error thrown by `viewContext.save()`.
     */
    func create(_ model: CategoryModel) throws {
        
        // garantía de thread-safety
        try viewContext.performAndWait {
            
            // Se crea un nuevo objeto "Entity" para mapear los campos que se van a guardar en la Entidad de Note.
            // Se debe utilizar el contexto que ya está instanciado.
            let entity = Category(context: viewContext)
            
            // Shared attributes (Abstract class):
            entity.dateCreated = model.dateCreated
            entity.dateModified = model.dateModified
            entity.id = model.id
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.dateLastUsed = model.dateLastUsed
            entity.icon = model.icon
            entity.name = model.name
            entity.type = model.type.rawValue
            entity.usageCount = Int64(model.usageCount)
            
            try viewContext.save()
        }
    }
    
    /**
     Update an existing `Category` with values from a `CategoryModel`.
    
     - Parameters;
        - model: Model containing the new values.
     
     - Throws: `.notFound` (from `fetchedCategory`) or any Core Data save error.
     */
    func update(_ model: CategoryModel) throws {
        try viewContext.performAndWait {
            let item = try fetch(model)
            
            // Shared attributes (Abstract class):
            item.dateModified = .now
            item.isActive = model.isActive
            
            // Entity-specific Attributes
            item.icon = model.icon
            item.name = model.name
            item.type = model.type.rawValue
            
            try viewContext.save()
        }
    }
    
    
    // MARK: DELETE
    
    func delete(_ model: CategoryModel) throws {
        try viewContext.performAndWait {
            let item = try fetch(model)
            
            viewContext.delete(item)
            try viewContext.save()
        }
    }
    
    func delete(at offsets: IndexSet, from items: [CategoryModel]) throws {
        for offset in offsets {
            let model = items[offset]
            try delete(model)
        }
    }
    
    
    // MARK: SHARED

    private func fetch(_ model: CategoryModel) throws -> Category {
        let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Category.self)
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            throw CDError.notFound(id: model.id, entity: Category.description())
        }
        
        return item
    }
    
    /**
     Public static version to be used by TransactionManager, so TransactionManager can find a Category by ID.
    */
    static func fetch(_ model: CategoryModel, viewContextArg: NSManagedObjectContext) throws -> Category? {
        let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Category.self)
        let itemCoreData = try viewContextArg.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            Logs.WriteMessage(CDError.notFound(id: model.id, entity: Category.description()).localizedDescription)
            return nil
        }
        
        return item
    }
}
