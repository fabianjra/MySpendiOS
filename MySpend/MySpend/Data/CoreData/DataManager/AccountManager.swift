//
//  AccountManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 4/7/25.
//

import CoreData

/**
 `AccountManager` is responsible for managing Core Data storage and handling all data-related operations throughout the app.
 It serves as a bridge between Core Data and the user interface.

 - Authors: Fabian Rodriguez
 - Version: 1.0
 */
struct AccountManager {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    
    // MARK: READ

    func fetchAll(predicateFormat: String = CDConstants.Predicates.isActive,
                  predicateArgs: [Any] = [true],
                  sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Account.dateCreated, ascending: true)])
    throws -> [AccountModel] {
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        
        let coreDataEntities = try viewContext.fetch(request)
        
        let models = coreDataEntities.map { entity in
            AccountModel(entity)
        }
        
        return models
    }
    
    
    // MARK: CREATE / UPDATE
    
    func create(_ model: AccountModel) throws {
        try viewContext.performAndWait {
            
            let entity = Account(context: viewContext)
            
            // Shared attributes (Abstract class):
            entity.dateCreated = model.dateCreated
            entity.dateModified = model.dateModified
            entity.id = model.id
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.icon = model.icon
            entity.name = model.name
            entity.notes = model.notes
            entity.type = model.type.rawValue
            entity.userId = model.userId
            //entity.transactions = [] // Se crea sin transacciones
            
            try viewContext.save()
        }
    }
    
    func update(_ model: AccountModel) throws {
        try viewContext.performAndWait {
            if let item = try AccountManager.fetch(model, viewContextArg: viewContext) {
                // Shared attributes (Abstract class):
                item.dateModified = .now
                item.isActive = model.isActive
                
                // Entity-specific Attributes
                item.icon = model.icon
                item.name = model.name
                item.notes = model.notes
                item.type = model.type.rawValue
                item.userId = model.userId
                
                try viewContext.save()
            } else {
                throw CDError.notFound(id: model.id, entity: Account.description())
            }
        }
    }
    
    
    // MARK: DELETE
    
    func delete(_ model: AccountModel) throws {
        try viewContext.performAndWait {
            if let item = try AccountManager.fetch(model, viewContextArg: viewContext) {
                viewContext.delete(item)
                try viewContext.save()
            } else {
                throw CDError.notFound(id: model.id, entity: Account.description())
            }
        }
    }
    
    func delete(at offsets: IndexSet, from items: [AccountModel]) throws {
        for offset in offsets {
            let model = items[offset]
            try delete(model)
        }
    }
    
    
    // MARK: SHARED
    
    /**
     Fetches the `Account` entity whose primary key matches `model.id`.
     
     Internally:
     1. Builds an `NSFetchRequest<Account>` via `CoreDataUtilities.createFetchRequest(ByID:entity:)`, using the model’s UUID string.
     2. Executes the request in `viewContextArg`.
     3. Logs a `.notFound` message and returns `nil` when no matching object is found; otherwise returns the first (and only) result.
     
     - Parameters:
        - model: `AccountModel` whose `id` is used as the lookup key.
        - viewContextArg: The managed-object context that executes the fetch.
     
     - Returns: The matching `Account` entity, or `nil` if none exists.
     - Throws: Any error thrown by `viewContextArg.fetch(_:)`.
     - Date: Jul 2025
     */
    static func fetch(_ model: AccountModel, viewContextArg: NSManagedObjectContext) throws -> Account? {
        let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Account.self)
        let itemCoreData = try viewContextArg.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            Logs.WriteMessage(CDError.notFound(id: model.id, entity: Account.description()).localizedDescription)
            return nil
        }
        
        return item
    }
    
    /**
     Returns the `Account` Core Data entity matching the given `AccountModel`,
     Creating and inserting a new one when none is found.
     
     Workflow:
     1. Calls `AccountManager.fetch(_:viewContextArg:)` to look up an existing `Account` whose **id** matches `model.id`.
     2. If the entity exists, it is returned as-is.
     3. If no match is found, a brand-new `Account` is created via
     `CoreDataUtilities.createAccountEntity(from:viewContext:)` and returned.
     
     - Parameters:
        - model: The `AccountModel` containing the identifier and field values to search for—or to seed a new entity with.
        - viewContextArg: The `NSManagedObjectContext` in which the lookup/insertion is performed.
     
     - Returns: A managed `Account` object residing in `viewContextArg`.
     - Throws: Rethrows any error raised by `AccountManager.fetch`.
     - Date: Jul 2025
     */
    static func resolve(from model: AccountModel, viewContextArg: NSManagedObjectContext) throws -> Account {
        if let existing = try AccountManager.fetch(model, viewContextArg: viewContextArg) {
            return existing
        }
        
        let entity = CoreDataUtilities.createAccountEntity(from: model, viewContext: viewContextArg)
        return entity
    }
}
