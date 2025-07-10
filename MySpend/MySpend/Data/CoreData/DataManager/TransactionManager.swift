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
            entity.amount = UtilsCurrency.makeDecimal(model.amount)
            entity.dateTransaction = model.dateTransaction
            entity.notes = model.notes
            
            // NOTA:
            // Con asignar uno de los lados basta; el otro se actualiza al guardar el contexto.
            // Es decir, no hay que ir a buscar la entidad Category para hacer la funcion de categoryEntity.addToTransaccions(entity).
            // Eso seria redundante (hace la misma operación dos veces) y solo gasta CPU.
            entity.category = try CategoryManager.resolve(from: model.category, viewContextArg: viewContext)
            entity.account = try AccountManager.resolve(from: model.account, viewContextArg: viewContext)
            
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
            item.amount = UtilsCurrency.makeDecimal(model.amount)
            item.dateTransaction = model.dateTransaction
            item.notes = model.notes
            item.category = try CategoryManager.resolve(from: model.category, viewContextArg: viewContext)
            item.account = try AccountManager.resolve(from: model.account, viewContextArg: viewContext)

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
    
    private func fetch(_ model: TransactionModel) throws -> Transaction {
        let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Transaction.self)
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            throw CDError.notFound(id: model.id, entity: Transaction.description())
        }
        
        return item
    }
}
