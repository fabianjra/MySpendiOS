//
//  NewTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Combine

@MainActor
class NewTransactionViewModel: ObservableObject {
    
    @Published var newTransaction = NewTransaction()
    
    func addNewTransaction() async -> ResponseModel {
        newTransaction.errorMessage = ""

        if newTransaction.amount.isEmptyOrWhitespace() || newTransaction.categoryId.isEmptyOrWhitespace() {
            //newTransaction.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
        }
        
        newTransaction.isLoading = true
        
        defer {
            newTransaction.isLoading = false
        }
        
        do {
            let transactionModel = TransactionModel(amount: Double(newTransaction.amount) ?? .zero,
                                                    date: newTransaction.dateString,
                                                    category: newTransaction.categoryId,
                                                    detail: newTransaction.notes,
                                                    type: newTransaction.transactionType)
            
            try await DatabaseStore.addNewTransaction(transactionModel: transactionModel)
            
            return ResponseModel(.successful)
        } catch {
            Logs.WriteCatchExeption(error: error)
            //newTransaction.errorMessage = error.localizedDescription
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
