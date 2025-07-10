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
    @Published var showNewTransactionModal = false
    @Published var showModifyTransactionModal = false
    
    @Published var isEditing = false
    @Published var selectedTransactions = Set<TransactionModel>()
    @Published var sortTransactionsBy = UserDefaultsManager.sorTransactions

    func deleteTransaction(_ model: TransactionModel) -> ResponseModel {
        do {
            try TransactionManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteMltipleTransactions() -> ResponseModel {
        do {
            for item in selectedTransactions {
                try TransactionManager(viewContext: viewContext).delete(item)
            }
            
            selectedTransactions.removeAll()
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error)
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
