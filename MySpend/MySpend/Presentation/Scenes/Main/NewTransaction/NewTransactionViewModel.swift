//
//  NewTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class NewTransactionViewModel: BaseViewModel {
    
    @Published var model = TransactionModel()
    @Published var showDatePicker = false
    @Published var selectedDate: Date = .now
    @Published var amountString: String = ""
    
    func onAppear() {
        model.date = Utils.dateToStringShort(date: selectedDate)
    }
    
    func addNewTransaction() async -> ResponseModel {
        if model.category.isEmptyOrWhitespace() {
            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
        }
        
        //TODO: Darle formato pero al string:
        let amountDecimal = UtilsCurrency.convertAmountStringToDecimal(amountString)
        
        model.amount = amountDecimal
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await TransactionsDatabase().addNewDocument(self.model)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
//    func addNewTransaction() async -> ResponseModel {
//        if model.categoryId.isEmptyOrWhitespace() {
//            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
//        }
//        
//        let amount = UtilsCurrency.convertAmountStringToDecimal(model.amount)
//        
//        let transactionModel = TransactionModel(amount: amount,
//                                                date: model.dateString,
//                                                categoryId: model.categoryId,
//                                                detail: model.notes,
//                                                type: model.transactionType)
//        
//        var response = ResponseModel()
//        
//        await performWithLoader {
//            do {
//                try await TransactionsDatabase().addNewTransaction(transactionModel: transactionModel)
//                response = ResponseModel(.successful)
//            } catch {
//                Logs.WriteCatchExeption(error: error)
//                response = ResponseModel(.error, error.localizedDescription)
//            }
//        }
//        
//        return response
//    }
}
