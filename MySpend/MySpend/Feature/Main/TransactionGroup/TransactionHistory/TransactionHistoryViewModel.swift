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
    @Published var selectedTransactions = Set<TransactionModel>()
    @Published var sortTransactionsBy = UserDefaultsManager.sorTransactions

    func delete(_ model: TransactionModel?) async -> ResponseModel {
        guard let model = model else { return ResponseModel(.successful) }
        
        do {
            try await TransactionManager(viewContext: viewContext).delete(model)
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
            //TODO: Pasar a un metodo que borre items masivamente. Crearlo en el TransactionManager
            for item in selectedTransactions {
                try await TransactionManager(viewContext: viewContext).delete(item)
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
