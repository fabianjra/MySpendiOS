//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Observation

@Observable
final class TransactionHistoryViewModel {
    
    var searchText = ""
    
    /*
     Caracteristicas de usar un set para la seleccion de items:
     
     Búsqueda (contains):       O(1) – tabla hash.
     Inserción / eliminación:   O(1) si el elemento existe.
     Duplicados:                Imposibles: cada elemento es único.
     Orden:                     No garantiza orden estable.
     */
    var selectedTransactions = Set<TransactionModel>()
    
    
    var showCreateTransaction = false
    
    var showUpdateTransaction = false
    var transactionToUpdate = TransactionModel()
    
    var showAlertDelete = false
    var transactionToDelete: TransactionModel?
    
    var showSearchView = false
    var showFilters = false

    func toggleTransactionSelection(_ transaction: TransactionModel) {
        if selectedTransactions.contains(transaction) {
            selectedTransactions.remove(transaction)
        } else {
            selectedTransactions.insert(transaction)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
//    var transactionsFiltered: [TransactionModel] = []
    
//    var sortTransactionsBy = UserDefaultsManager.sorTransactions_ORIGINAL
    
    // MARK: - CORE DATA
//    private let viewContext: NSManagedObjectContext
//    
//    init(viewContext: NSManagedObjectContext? = nil) {
//        self.viewContext = viewContext ?? CoreDataUtilities.getViewContext
//    }
    
//    func favorite(_ model: TransactionModel) async -> ToastResponse {
//        do {
//            try await TransactionCoreDataManager(viewContext).updateFavorite(model)
//            
//            return ToastResponse()
//        } catch {
//            Logger.exception(error, type: .CoreData)
//            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
//        }
//    }
    
//    /*
//     Si solamente hay una transacción seleccionada, hace un Toggle para cambiar su estado de favorito.
//     Si hay varias transacciones seleccionadas, entonces marca todas como favoritas.
//     */
//    func favoriteMltiple(_ newState: Bool) async -> ToastResponse {
//        defer {
//            selectedTransactions.removeAll()
//        }
//        
//        do {
//            if selectedTransactions.count == 1 {
//                
//                if let selectedTransaction = selectedTransactions.first {
//                    try await TransactionCoreDataManager(viewContext).updateFavorite(selectedTransaction, newState: newState)
//                }
//                
//            } else {
//                try await TransactionCoreDataManager(viewContext).favoriteMultiple(Array(selectedTransactions), newState: newState)
//            }
//            
//            return ToastResponse(.responseSuccesful, .ok)
//        } catch {
//            Logger.exception(error, type: .CoreData)
//            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
//        }
//    }
    
//    func delete(_ model: TransactionModel?) async -> ToastResponse {
//        guard let model = model else { return ToastResponse() }
//        
//        do {
//            try await TransactionCoreDataManager(viewContext).delete(model)
//            return ToastResponse(.responseSuccesful, .ok)
//        } catch {
//            Logger.exception(error, type: .CoreData)
//            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
//        }
//    }
//    
//    func deleteMltiple() async -> ToastResponse {
//        defer {
//            selectedTransactions.removeAll()
//        }
//        
//        do {
//            //let idsToDelete = Set(selectedTransactions.map { $0.id })
//            //try await TransactionManager(viewContext: viewContext).deleteMultiple(entityName: Transaction.entityName, idsToDelete: idsToDelete)
//
//            for item in selectedTransactions {
//                try await TransactionCoreDataManager(viewContext).delete(item)
//            }
//            
//            return ToastResponse(.responseTransactionDeleted(selectedTransactions.count), .ok)
//        } catch {
//            Logger.exception(error, type: .CoreData)
//            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
//        }
//    }
//    
//    /**
//     Updates the sort selection to store in UserDefaults.
//     */
//    func updateSelectedSort() {
//        UserDefaultsManager.sorTransactions_ORIGINAL = sortTransactionsBy
//    }
//    
//    /**
//     Deletes the sort selection object in UserDefaults.
//     */
//    func resetSelectedSort() {
//        UserDefaultsManager.removeValue(for: .sortTransactions)
//        sortTransactionsBy = UserDefaultsManager.sorTransactions_ORIGINAL
//    }
}

