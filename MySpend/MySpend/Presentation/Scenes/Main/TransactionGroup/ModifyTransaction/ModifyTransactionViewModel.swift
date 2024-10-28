//
//  ModifyTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/10/24.
//

import Foundation

class ModifyTransactionViewModel: BaseViewModel {
    
    @Published var selectedDate: Date = .now
    @Published var amountString: String = ""
    
    @Published var showDatePicker = false
    @Published var showCategoryList = false
    @Published var showAlert = false
    
    func onAppear(_ model: TransactionModel) {
        selectedDate = Utils.stringShortDateToDate(dateShort: model.date)
        amountString = model.amount.convertAmountDecimalToString()
    }
    
    func modifyTransaction(_ model: TransactionModel) async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace() {
            return ResponseModel(.error, Messages.emptySpaces.localizedDescription)
        }
        
        //Firebase necesita guardar el valor como decimal, pero los formatos del monto en pantalla se trabajan en string:
        var mutableModel = model
        
        let amountDecimal = UtilsCurrency.convertAmountStringToDecimal(amountString)
        mutableModel.amount = amountDecimal
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await Repository().modifyDocument(mutableModel, documentId: mutableModel.id, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
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
}
