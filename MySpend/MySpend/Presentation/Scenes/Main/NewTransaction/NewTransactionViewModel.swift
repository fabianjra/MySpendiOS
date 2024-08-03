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
    
    func addNewTransaction() async {
        newTransaction.errorMessage = ""

        if newTransaction.amount.isEmptyOrWhitespace() || newTransaction.category.isEmptyOrWhitespace() {
            newTransaction.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        newTransaction.isLoading = true
        
        defer {
            newTransaction.isLoading = false
        }
        
        do {
            let categoryModel = CategoryModel(description: newTransaction.category)
            
            let transactionModel = TransactionModel(amount: Double(newTransaction.amount),
                                                    date: newTransaction.dateString,
                                                    category: categoryModel,
                                                    detail: newTransaction.notes,
                                                    type: newTransaction.transactionType)
            
            try await DatabaseStore.addNewTransaction(transactionModel: transactionModel)
        } catch {
            newTransaction.errorMessage = error.localizedDescription
        }
    }
}
