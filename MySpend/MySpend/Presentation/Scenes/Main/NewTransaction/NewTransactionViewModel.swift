//
//  NewTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Combine

class NewTransactionViewModel: BaseViewModel {
    
    @Published var model = NewTransaction()
    @Published var showDatePicker = false
    
    func onAppear() {
        model.dateString = Utils.dateToStringShort(date: model.selectedDate)
    }
    
    func addNewTransaction() async -> ResponseModel {
        if model.categoryId.isEmptyOrWhitespace() {
            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
        }
        
        let transactionModel = TransactionModel(amount: model.amount,
                                                date: model.dateString,
                                                categoryId: model.categoryId,
                                                detail: model.notes,
                                                type: model.transactionType)
        
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
