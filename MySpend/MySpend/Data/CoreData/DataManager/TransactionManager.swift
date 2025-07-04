//
//  TransactionManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 3/7/25.
//

import CoreData

/**
 `TransactionManager` is responsible for managing Core Data storage and handling all data-related operations throughout the app.
 It serves as a bridge between Core Data and the user interface.

 - Authors: Fabian Rodriguez
 - Version: 1.0
 */
struct TransactionManager {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    
    // MARK: READ
    
    func fetchAll(predicateFormat: String = CDConstants.Predicates.isActive,
                              predicateArgs: [Any] = [true],
                              sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Transaction.dateTransaction, ascending: true)])
    throws -> [TransactionModel] {
        
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        
        let coreDataEntities = try viewContext.fetch(request)
        
        let models = coreDataEntities.map { entity in
            TransactionModel(entity)
        }
        
        return models
    }
    
    
    // MARK: CREATE / UPDATE
    
    func create(_ model: TransactionModel) throws {
        try viewContext.performAndWait {
            
            let entity = Transaction(context: viewContext)
            
            // Shared attributes (Abstract class):
            entity.dateCreated = model.dateCreated
            entity.dateModified = model.dateModified
            entity.id = model.id
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.amount = try UtilsCurrency.makeDecimal(model.amount)
            entity.dateTransaction = model.dateTransaction
            entity.notes = model.notes
            entity.category = try resolveCategory(from: model.category)
            
            try viewContext.save()
        }
    }
    
    func update(_ model: TransactionModel) throws {
        try viewContext.performAndWait {
            let item = try fetch(model)
            
            // Shared attributes (Abstract class):
            item.dateModified = .now
            item.isActive = model.isActive
            
            // Entity-specific Attributes
            item.amount = try UtilsCurrency.makeDecimal(model.amount)
            item.notes = model.notes
            item.category = try resolveCategory(from: model.category)

            try viewContext.save()
        }
    }
    
    
    // MARK: DELETE
    
    func delete(_ model: TransactionModel) throws {
        try viewContext.performAndWait {
            let item = try fetch(model)
            
            viewContext.delete(item)
            try viewContext.save()
        }
    }
    
    func delete(at offsets: IndexSet, from items: [TransactionModel]) throws {
        for offset in offsets {
            let model = items[offset]
            try delete(model)
        }
    }
    
    
    // MARK: SHARED
    
    static func createFetchRequest(_ model: TransactionModel) -> NSFetchRequest<Transaction> {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CDConstants.Predicates.findItemById, model.id.uuidString)
        fetchRequest.fetchLimit = 1
        return fetchRequest
    }
    
    private func fetch(_ model: TransactionModel) throws -> Transaction {
        let fetchRequest = TransactionManager.createFetchRequest(model)
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            throw CDError.notFound(id: model.id, entity: Transaction.description())
        }
        
        return item
    }
    
    private func resolveCategory(from model: CategoryModel) throws -> Category {
        if let existing = try CategoryManager.fetch(model, viewContextArg: viewContext) {
            existing.dateLastUsed = .now
            existing.usageCount += 1
            return existing // encontrada
        }
        
        // Si no existe, se crea a partir del modelo
        let entity = Category(context: viewContext)
        entity.id            = model.id
        entity.dateCreated   = model.dateCreated
        entity.dateModified  = model.dateModified
        entity.dateLastUsed  = model.dateLastUsed
        entity.icon          = model.icon
        entity.isActive      = model.isActive
        entity.name          = model.name
        entity.type          = model.type.rawValue
        entity.usageCount    = Int64(model.usageCount + 1)
        
        return entity
    }
}
