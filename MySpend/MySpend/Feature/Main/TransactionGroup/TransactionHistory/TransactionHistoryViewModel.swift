//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModelFB {
    
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    @Published var showNewTransactionModal = false
    @Published var showModifyTransactionModal = false
    
    @Published var isEditing = false
    @Published var selectedTransactions = Set<TransactionModelFB>()
    @Published var sortTransactionsBy = UserDefaultsManager.sorTransactions
    
    func deleteTransaction(_ model: TransactionModelFB) async -> ResponseModelFB {
        var response = ResponseModelFB()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .transactions)
                
                response = ResponseModelFB(.successful)
            } catch {
                Logs.CatchException(error)
                response = ResponseModelFB(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteMltipleTransactions() async -> ResponseModelFB {
        var response = ResponseModelFB()
        
        await performWithLoaderSecondary {
            do {
                let selectedDocumentIds = self.selectedTransactions.map { $0.id }

                try await Repository().deleteDocuments(selectedDocumentIds, forSubCollection: .transactions)
                
                self.selectedTransactions.removeAll()
                response = ResponseModelFB(.successful)
            } catch {
                Logs.CatchException(error)
                response = ResponseModelFB(.error, error.localizedDescription)
            }
        }
        
        return response
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
