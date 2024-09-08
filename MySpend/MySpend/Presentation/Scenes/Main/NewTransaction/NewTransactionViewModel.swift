//
//  NewTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Combine

class NewTransactionViewModel: BaseViewModel {
    
    @Published var newTransaction = NewTransaction()
    @Published var showDatePicker = false
    
    func addNewTransaction() async -> ResponseModel {
        errorMessage = ""

        if newTransaction.amount.isEmptyOrWhitespace() || newTransaction.categoryId.isEmptyOrWhitespace() {
            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
        }
        
        let transactionModel = TransactionModel(amount: Double(newTransaction.amount) ?? .zero, //TODO: Revisar cuando pueda ser error.
                                                date: newTransaction.dateString,
                                                categoryId: newTransaction.categoryId,
                                                detail: newTransaction.notes,
                                                type: newTransaction.transactionType)
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await DatabaseStore().addNewTransaction(transactionModel: transactionModel)
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
