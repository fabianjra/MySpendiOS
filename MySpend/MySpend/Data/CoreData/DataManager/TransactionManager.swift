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
    
    private typealias predicate = CDConstants.Predicate
    
    // MARK: READ
    
    func fetchAll(predicateFormat: String = predicate.byIsActive,
                  predicateArgs: [Any] = [true],
                  sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Transaction.dateTransaction, ascending: true)]) async throws -> [TransactionModel] {
        
        try await viewContext.perform {
            
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            request.sortDescriptors = sortDescriptors // El ordenamiento se hace a la hora de mostrar los datos
            request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
            
            let coreDataEntities = try viewContext.fetch(request)
            
            let models = coreDataEntities.map { entity in
                TransactionModel(entity)
            }
            
            return models
        }
    }
    
    
    // MARK: CREATE / UPDATE
    
    func create(_ model: TransactionModel) async throws {
        
        let categoryResolved = try await CategoryManager.resolve(from: model.category, viewContextArg: viewContext)
        let accountResolved = try await AccountManager.resolve(from: model.account, viewContextArg: viewContext)
        
        try await viewContext.perform {
            
            let entity = Transaction(context: viewContext)
            
            // Shared attributes (Abstract class):
            entity.dateCreated = .now
            entity.dateModified = .now
            entity.id = model.id
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.amount = UtilsCurrency.makeNSDecimal(model.amount)
            entity.dateTransaction = model.dateTransaction.dateWithCurrentTime
            entity.notes = model.notes
            
            // NOTA:
            // Con asignar uno de los lados basta; el otro se actualiza al guardar el contexto.
            // Es decir, no hay que ir a buscar la entidad Category para hacer la funcion de categoryEntity.addToTransaccions(entity).
            // Eso seria redundante (hace la misma operación dos veces) y solo gasta CPU.
            entity.category = categoryResolved
            entity.account = accountResolved
            
            // Aumenta el valor de la cantidad de usos para la categoria:
            entity.category?.dateLastUsed = .now
            entity.category?.usageCount = (entity.category?.usageCount ?? .zero) + 1
            
            try viewContext.save()
        }
    }
    
    func update(_ model: TransactionModel) async throws {
        
        let categoryResolved = try await CategoryManager.resolve(from: model.category, viewContextArg: viewContext)
        let accountResolved = try await AccountManager.resolve(from: model.account, viewContextArg: viewContext)
        
        try await viewContext.perform {
            guard let entity = try CoreDataUtilities.fetch(ByID: model.id.uuidString,
                                                           entity: Transaction.self,
                                                           viewContextArg: viewContext) else {
                throw CDError.notFoundUpdate(entity: Transaction.entityName)
            }
            
            // Shared attributes (Abstract class):
            entity.dateModified = .now
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.amount = UtilsCurrency.makeNSDecimal(model.amount)
            entity.dateTransaction = model.dateTransaction.dateWithCurrentTime
            entity.notes = model.notes
            entity.category = categoryResolved
            entity.account = accountResolved
            
            entity.category?.dateLastUsed = .now
            entity.category?.usageCount = (entity.category?.usageCount ?? .zero) + 1
            
            try viewContext.save()
        }
    }
    
    
    // MARK: DELETE
    
    func delete(_ model: TransactionModel) async throws {
            try await viewContext.perform {
                guard let entity = try CoreDataUtilities.fetch(ByID: model.id.uuidString,
                                                               entity: Transaction.self,
                                                               viewContextArg: viewContext) else {
                    throw CDError.notFoundUpdate(entity: Transaction.entityName)
                }
                
                viewContext.delete(entity)
                try viewContext.save()
            }
    }
    
    func delete(at offsets: IndexSet, from items: [TransactionModel]) async throws {
        for offset in offsets {
            let model = items[offset]
            try await delete(model)
        }
    }
    
    /**
     Deletes all `Transaction` entities whose **id** matches the models supplied.
     
     - Important:
     * Executes **inside** `viewContext.perform{}` so the UI thread is never blocked.
     * Uses `NSBatchDeleteRequest` (O-log n) — Core Data elimina a nivel de SQLite sin cargar cada fila en memoria.
     * Merges the resulting `objectID`s back into `viewContext` so any SwiftUI/List that observes the context refreshes automatically.
     */
    private func deleteMultiple_ERROR_Could_not_merge_changes(entityName: String, idsToDelete: Set<UUID>) async throws {
        if idsToDelete.isEmpty { return }
        
        let bgContext = PersistenceController.shared.container.newBackgroundContext()
        bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let objIDs: [NSManagedObjectID] = try await bgContext.perform {
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetch.predicate = NSPredicate(format: predicate.byMultipleID, idsToDelete)
            
            let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
            deleteReq.resultType = .resultTypeObjectIDs
            
            guard let result = try bgContext.execute(deleteReq) as? NSBatchDeleteResult,
                  let ids = result.result as? [NSManagedObjectID] else { return [] }
            
            return ids
        }
        
        // Fusiona en el viewContext para refrescar la UI
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objIDs]
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: changes,
            into: [viewContext]
        )
        
        // Optional: save pending changes that *this* context might have
        // Normalmente no hay cambios adicionales, pero si los hubiera (por ejemplo, contadores actualizados) quedan consolidados.
        if viewContext.hasChanges {
            try viewContext.save()
        }
        
        /*
         NOTA: Si luego se usa un background context en lugar de viewContext,
         se debe pasar ese contexto al perform {} y en el mergeChanges indica ambos contextos (bgContext y viewContext) para que la UI reciba la notificación.
         */
    }
    
    // MARK: SHARED
    
    /**
     Counts the transactions that would become **invalid** after changing an account to `newAccountType`.
    
     A transaction is “invalid” when:
       1. It belongs to the account whose primary-key is `accountID`, **and**
       2. Its category type is *not* accepted by the `newAccountType`.
    
     Rules:
     * `.general` accepts both category types → always returns 0.
     * `.expenses` rejects categories of type `.income`.
     * `.incomes`  rejects categories of type `.expense`.
    
     - Parameters:
       - accountID: UUID string of the account being edited.
       - newAccountType: The prospective `AccountType`.
     
     - Returns: Number of incompatible transactions.
     - Throws: Any error thrown by `viewContext.count(for:)`.
     */
    func fetchIncompatibleTypeCount(currentAccountID id: String, newAccountType: AccountType) async throws -> Int {
        try await viewContext.perform {
            
            // 1.  General accepts everything -> nothing to validate
            guard newAccountType != .general else { return .zero }
            
            // 2.  Predicate for the account
            let accountPredicate = NSPredicate(format: predicate.byAccountId, id)
            
            // 3.  Predicate for the *disallowed* category type
            let disallowedPredicate: NSPredicate
            
            switch newAccountType {
            case .expenses: disallowedPredicate = NSPredicate(format: predicate.byCategoryType, CategoryType.income.rawValue)
                
            case .incomes: disallowedPredicate = NSPredicate(format: predicate.byCategoryType, CategoryType.expense.rawValue)
                
            case .general: return .zero
            }
            
            // 4.  Combined query (COUNT only)
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            request.predicate   = NSCompoundPredicate(andPredicateWithSubpredicates: [accountPredicate, disallowedPredicate])
            request.resultType  = .countResultType // fastest
            
            return try viewContext.count(for: request)
        }
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
     * Category type *expense* is only compatible with account type *expenses* or *general*.
     * Category type *income* is only compatible with account type *incomes* or *general*.
    
     - Parameters:
       - currentCategoryID: The UUID string of the category being modified.
       - newCategoryType:   The target `CategoryType` selected by the user.
    
     - Returns: The number of incompatible transactions found.
     - Throws: Any error thrown by `viewContext.count(for:)`.
     */
    func fetchIncompatibleTypeCount(currentCategoryID id: String, newCategoryType: CategoryType) async throws -> Int {
        try await viewContext.perform {
            
            // Condicion 1: Obtendra las transacciones que usen la categoria actual
            let categoryPredicate = NSPredicate(format: predicate.byCategoryId, id)
            
            // Condicion 2: Verifica si el Account al que pertenece la Transaction NO es compatible con el nuevo tipo de Category
            
            // Condicion 2: Obtendra las transacciones que no sean compatibles con el nuevo tipo de categoria seleccionado,
            // asi se puede saber si existen transacciones que no deberian poder actualizarse por perteneceer a una categoria incompatible con el tipo de cuenta.
            let incompatiblePredicate: NSPredicate
            
            switch newCategoryType {
            case .expense:
                // No se permiten cuentas tipo incomes
                incompatiblePredicate = NSPredicate(format: predicate.byAccountType, AccountType.incomes.rawValue)
                
            case .income:
                // No se permiten cuentas tipo expenses
                incompatiblePredicate = NSPredicate(format: predicate.byAccountType, AccountType.expenses.rawValue)
            }
            
            // Combinar ambos predicados
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, incompatiblePredicate])
            request.resultType = .countResultType // Faster call to CoreData
            
            return try viewContext.count(for: request)
        }
    }
}
