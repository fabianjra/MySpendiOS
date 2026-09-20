//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation
import CoreData

@Observable
@MainActor
final class TransactionHistoryViewModel {
    
    var isEditing = false
    var searchText = ""
    
    /*
     Caracteristicas de usar un set para la seleccion de items:
     
     Búsqueda (contains):       O(1) – tabla hash.
     Inserción / eliminación:   O(1) si el elemento existe.
     Duplicados:                Imposibles: cada elemento es único.
     Orden:                     No garantiza orden estable.
     */
    var selectedTransactions = Set<TransactionModel>()
    var transactionsFiltered: [TransactionModel] = []
    
    var sortTransactionsBy = UserDefaultsManager.sorTransactions
    
    // MARK: - CORE DATA
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext? = nil) {
        self.viewContext = viewContext ?? CoreDataUtilities.getViewContext
    }
    
    func favorite(_ model: TransactionModel) async -> ResponseToast {
        do {
            try await TransactionManager(viewContext).updateFavorite(model)
            
            return ResponseToast()
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    /*
     Si solamente hay una transacción seleccionada, hace un Toggle para cambiar su estado de favorito.
     Si hay varias transacciones seleccionadas, entonces marca todas como favoritas.
     */
    func favoriteMltiple(_ newState: Bool) async -> ResponseToast {
        defer {
            isEditing = false
            selectedTransactions.removeAll()
        }
        
        do {
            if selectedTransactions.count == 1 {
                
                if let selectedTransaction = selectedTransactions.first {
                    try await TransactionManager(viewContext).updateFavorite(selectedTransaction, newState: newState)
                }
                
            } else {
                try await TransactionManager(viewContext).favoriteMultiple(Array(selectedTransactions), newState: newState)
            }
            
            return ResponseToast(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func delete(_ model: TransactionModel?) async -> ResponseToast {
        guard let model = model else { return ResponseToast() }
        
        do {
            try await TransactionManager(viewContext).delete(model)
            return ResponseToast(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func deleteMltiple() async -> ResponseToast {
        defer {
            isEditing = false
            selectedTransactions.removeAll()
        }
        
        do {
            //let idsToDelete = Set(selectedTransactions.map { $0.id })
            //try await TransactionManager(viewContext: viewContext).deleteMultiple(entityName: Transaction.entityName, idsToDelete: idsToDelete)

            for item in selectedTransactions {
                try await TransactionManager(viewContext).delete(item)
            }
            
            return ResponseToast(.responseTransactionDeleted(selectedTransactions.count), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
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

