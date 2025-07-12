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
    
    private func fetch(_ model: TransactionModel) throws -> Transaction {
        let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Transaction.self)
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            throw CDError.notFoundFetch(entity: Transaction.description())
        }
        
        return item
    }
    
    
    // MARK: SHARED
    
    func fetchAllCount(byAccountID id: String) throws -> Int {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: CDConstants.Predicates.findItemByAccountId, id)
        request.resultType = .countResultType // Faster call to CoreData
        
        let count = try viewContext.count(for: request)
        return count
    }
    
    /**
     Returns the number of `Transaction` records that would become **incompatible** after changing a category’s type.
    
     “Incompatible” means:
     * The transaction currently uses the category whose primary-key is `currentCategoryID`.
     * The account linked to that transaction has a type that does **not** accept the prospective `newCategoryType`.
    
     Internally:
     1. Builds an `NSPredicate` that matches `category.id == currentCategoryID`.
     2. Adds a second predicate whose value depends on `newCategoryType` (`account.type == .incomes` when switching to `.expense`, and vice-versa).
     3. Combines both predicates with **AND** (`NSCompoundPredicate`).
     4. Executes a **count-only** fetch (`resultType = .countResultType`) for maximum performance.
    
     Use this method when the user attempts to change a category from *expense → income* (or the reverse) and you need to block the operation if any existing transactions would violate the account-type rules.
     Category type *expense* is only compatible with account type *expenses* or *general*.
     Category type *income* is only compatible with account type *incomes* or *general*.
    
     - Parameters:
       - currentCategoryID: The UUID string of the category being modified.
       - newCategoryType:   The target `CategoryType` selected by the user.
    
     - Returns: The number of incompatible transactions found.
     */
    func fetchIncompatibleTypeCount(currentCategoryID id: String, newCategoryType: CategoryType) throws -> Int {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        // Condicion 1: Obtendra las transacciones que usen la categoria actual
        let categoryPredicate = NSPredicate(format: "category.id == %@", id)

        // Condicion 2: Verifica si el Account al que pertenece la Transaction NO es compatible con el nuevo tipo de Category
        
        // Condicion 2: Obtendra las transacciones que no sean compatibles con el nuevo tipo de categoria seleccionado,
        // asi se puede saber si existen transacciones que no deberian poder actualizarse por perteneceer a una categoria incompatible con el tipo de cuenta.
        let incompatiblePredicate: NSPredicate
        switch newCategoryType {
        case .expense:
            // No se permiten cuentas tipo incomes
            incompatiblePredicate = NSPredicate(format: "account.type == %@", AccountType.incomes.rawValue)
            
        case .income:
            // No se permiten cuentas tipo expenses
            incompatiblePredicate = NSPredicate(format: "account.type == %@", AccountType.expenses.rawValue)
        }

        // Combinar ambos predicados
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, incompatiblePredicate])
        request.resultType = .countResultType // Faster call to CoreData
        
        return try viewContext.count(for: request)
    }
}
