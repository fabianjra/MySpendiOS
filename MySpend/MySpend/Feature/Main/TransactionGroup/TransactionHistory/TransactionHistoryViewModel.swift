//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    
    @Published var isEditing = false
    
    /*
     Caracteristicas de usar un set para la seleccion de items:
     
     Búsqueda (contains):       O(1) – tabla hash.
     Inserción / eliminación:   O(1) si el elemento existe.
     Duplicados:                Imposibles: cada elemento es único.
     Orden:                     No garantiza orden estable.
     */
    @Published var selectedTransactions = Set<TransactionModel>()
    @Published var sortTransactionsBy = UserDefaultsManager.sorTransactions

    func delete(_ model: TransactionModel?) async -> ResponseModel {
        guard let model = model else { return ResponseModel(.successful) }
        
        do {
            try await TransactionManager().delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteMltiple() async -> ResponseModel {
        defer {
            isEditing = false
        }
        
        do {
            //let idsToDelete = Set(selectedTransactions.map { $0.id })
            
            //try await TransactionManager(viewContext: viewContext).deleteMultiple(entityName: Transaction.entityName, idsToDelete: idsToDelete)
            
            for item in selectedTransactions {
                try await TransactionManager().delete(item)
            }
            
            selectedTransactions.removeAll()
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    /**
     Updates the sort selection to store in UserDefaults.
     */
    func updateSelectedSort() {
        UserDefaultsManager.sorTransactions = sortTransactionsBy
    }
    
    /**
     Deletes the sort selection object in UserDefaults.
     */
    func resetSelectedSort() {
        UserDefaultsManager.removeValue(for: .sortTransactions)
        sortTransactionsBy = UserDefaultsManager.sorTransactions
    }
}
