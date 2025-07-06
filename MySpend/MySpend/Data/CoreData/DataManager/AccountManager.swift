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
            entity.transactions = [] // Se crea sin transacciones
            
            try viewContext.save()
        }
    }
    
    func update(_ model: AccountModel) throws {
        try viewContext.performAndWait {
            let item = try fetch(model)
            
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
        }
    }
    
    
    // MARK: DELETE
    
    func delete(_ model: AccountModel) throws {
        try viewContext.performAndWait {
            let item = try fetch(model)
            
            viewContext.delete(item)
            try viewContext.save()
        }
    }
    
    func delete(at offsets: IndexSet, from items: [AccountModel]) throws {
        for offset in offsets {
            let model = items[offset]
            try delete(model)
        }
    }
    
    
    // MARK: SHARED
    
    private func fetch(_ model: AccountModel) throws -> Account {
        let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Account.self)
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            throw CDError.notFound(id: model.id, entity: Account.description())
        }
        
        return item
    }
    
    /**
     Public static version to be used by TransactionManager, so TransactionManager can find an Account by ID.
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
}
