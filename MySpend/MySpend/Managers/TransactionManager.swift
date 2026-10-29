//
//  TransactionManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/26.
//

import CoreData
import Combine

@MainActor
@Observable
final class TransactionManager {
    static let shared = TransactionManager()

    private let coreDataManager: TransactionCoreDataManager
    private var transactions: [TransactionModel] = []
    var transactionsCount: Int { transactions.count }
    
    
    // MARK: OBSERVABLES
    
    private var viewContextObserver: AnyCancellable?
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.coreDataManager = TransactionCoreDataManager(viewContext)
        
        Task {
            await refreshTransactions()
        }
        
        startObserveViewContextChanges()
    }
    
    private convenience init() {
        self.init(viewContext: CoreDataUtilities.getViewContext)
    }
    
    private func refreshTransactions() async {
        do {
            transactions = try await coreDataManager.fetchAll()
            
            //updateDefaultAccount()
            //cleanFilteredAccounts()
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    private func startObserveViewContextChanges() {
        guard viewContextObserver == nil else { return }
        
        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                
                Task { @MainActor in
                    await self?.refreshTransactions()
                }
            }
    }
    
    
    // MARK: DEFAULT ACCOUNT
    
    //TODO: ...
    
    
    // MARK: ORDENAMIENTO
    
    var sortedTransactions: [TransactionModel] {
        //accounts.sortedAccounts(by: sortSelection)
        return [] //TODO: HACER METODO
    }
    
    var sortSelection = UserDefaultsManager.sorTransactions {
        didSet { UserDefaultsManager.sorTransactions = sortSelection }
    }
    
    func resetSort() {
        sortSelection = TransactionSortConfiguration()
    }
}


// MARK: CRUD

extension TransactionManager {
    
    func create(_ transaction: TransactionModel, isFavorite: Bool) async -> ToastResponse {
        //Validar si se puede utilizar el category como opcional en el modelo de transactionModel.
        //Asi se setea luego a null, cuando cambie la seleccion y asi se valida directamente con category en nil.
        if transaction.category.name.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }

        let amountString = transaction.amount.convertAmountDecimalToString
        
        var itemMutated = transaction
        itemMutated.amount = amountString.convertAmountToDecimal
        itemMutated.dateTransaction = UtilsDate.normalizeTransactionDate(itemMutated.dateTransaction)
        itemMutated.favorite = isFavorite
        
        do {
            try await coreDataManager.create(transaction)
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func update(_ transaction: TransactionModel, isFavorite: Bool) async -> ToastResponse {
        if transaction.category.name.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
        let amountString = transaction.amount.convertAmountDecimalToString
        
        var itemMutated = transaction
        itemMutated.amount = amountString.convertAmountToDecimal
        itemMutated.favorite = isFavorite
        
        do {
            try await coreDataManager.update(transaction)
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func delete(_ transaction: TransactionModel) async -> ToastResponse {
        do {
            try await coreDataManager.delete(transaction)
            
            return ToastResponse(.responseCategoriesDeleted(.zero), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func delete(_ selectedTransactions: Set<TransactionModel>) async -> ToastResponse {
        do {
            for item in selectedTransactions {
                try await coreDataManager.delete(item)
            }
            
            return ToastResponse(.responseCategoriesDeleted(selectedTransactions.count), .ok)
        } catch {
            Logger.exception(error)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
}

