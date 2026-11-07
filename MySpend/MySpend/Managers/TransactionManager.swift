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
    
    
    // MARK: FILTROS
    
    /**
     Filters transactions by the selected date interval and sorts the results.

     TODO: Optimize performance for large datasets by moving filtering and sorting
     to Core Data using NSFetchRequest, NSPredicate, and NSSortDescriptor.
     
     This will avoid loading and processing all transactions in memory.
     */
    func filteredAndSortedTransactions(by dateTimeInterval: DateTimeInterval, selectedDate: Date) -> [TransactionModel] {
        return transactions
            .filteredTransactions(by: dateTimeInterval, selectedDate: selectedDate)
            .sortedTransactions(by: sortSelection)
    }
    
    
    // MARK: ORDENAMIENTO
    
    var sortSelection = UserDefaultsManager.sorTransactions {
        didSet { UserDefaultsManager.sorTransactions = sortSelection }
    }
    
    func resetSort() {
        sortSelection = TransactionSortConfiguration()
    }
}


// MARK: CRUD

extension TransactionManager {
    
    func create(_ transaction: TransactionModel) async -> ToastResponse {
        //Validar si se puede utilizar el category como opcional en el modelo de transactionModel.
        //Asi se setea luego a null, cuando cambie la seleccion y asi se valida directamente con category en nil.
        if transaction.category.name.isEmptyOrWhitespace || transaction.account.name.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }

        do {
            try await coreDataManager.create(transaction)
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func update(_ transaction: TransactionModel) async -> ToastResponse {
        if transaction.category.name.isEmptyOrWhitespace || transaction.account.name.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
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
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
}


// MARK: FAVORITE

extension TransactionManager {
    
    func favorite(_ model: TransactionModel) async -> ToastResponse {
        do {
            try await coreDataManager.updateFavorite(model)
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    /*
     Si solamente hay una transacción seleccionada, hace un Toggle para cambiar su estado de favorito.
     Si hay varias transacciones seleccionadas, entonces marca todas como favoritas.
     */
    func favorite(_ selectedTransactions: Set<TransactionModel>, newState: Bool) async -> ToastResponse {
//        defer {
//            selectedTransactions.removeAll()
//        }
        
        do {
            if selectedTransactions.count == 1 {
                
                if let selectedTransaction = selectedTransactions.first {
                    try await TransactionCoreDataManager(viewContext).updateFavorite(selectedTransaction, newState: newState)
                }
                
            } else {
                try await TransactionCoreDataManager(viewContext).favoriteMultiple(Array(selectedTransactions), newState: newState)
            }
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
}
