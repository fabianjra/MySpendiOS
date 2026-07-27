//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var isEditing = false
    @Published var searchText = ""
    
    /*
     Caracteristicas de usar un set para la seleccion de items:
     
     Búsqueda (contains):       O(1) – tabla hash.
     Inserción / eliminación:   O(1) si el elemento existe.
     Duplicados:                Imposibles: cada elemento es único.
     Orden:                     No garantiza orden estable.
     */
    @Published var selectedTransactions = Set<TransactionModel>()
    @Published var transactionsFiltered: [TransactionModel] = []
    
    @Published var sortTransactionsBy = UserDefaultsManager.sorTransactions
    
    func favorite(_ model: TransactionModel) async -> ResponseModel {
        do {
            try await TransactionManager(viewContext).updateFavorite(model)
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    /*
     Si solamente hay una transacción seleccionada, hace un Toggle para cambiar su estado de favorito.
     Si hay varias transacciones seleccionadas, entonces marca todas como favoritas.
     */
    func favoriteMltiple(_ newState: Bool) async -> ResponseModel {
        defer {
            isEditing = false
        }
        
        do {
            if selectedTransactions.count == 1 {
                
                if let selectedTransaction = selectedTransactions.first {
                    try await TransactionManager(viewContext).updateFavorite(selectedTransaction, newState: newState)
                }
                
            } else {
                try await TransactionManager(viewContext).favoriteMultiple(Array(selectedTransactions), newState: newState)
            }
            
            selectedTransactions.removeAll()
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete(_ model: TransactionModel?) async -> ResponseModel {
        guard let model = model else { return ResponseModel(.successful) }
        
        do {
            try await TransactionManager(viewContext).delete(model)
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
                try await TransactionManager(viewContext).delete(item)
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

