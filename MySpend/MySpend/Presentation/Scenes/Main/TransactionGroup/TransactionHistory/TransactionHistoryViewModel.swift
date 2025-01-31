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
    
    func deleteTransaction(_ model: TransactionModel) async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteMltipleTransactions() async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                let selectedDocumentIds = self.selectedTransactions.map { $0.id }

                try await Repository().deleteDocuments(selectedDocumentIds, forSubCollection: .transactions)
                
                self.selectedTransactions.removeAll()
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
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
