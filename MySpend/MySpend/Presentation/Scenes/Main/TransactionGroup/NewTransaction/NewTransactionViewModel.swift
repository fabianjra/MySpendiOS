//
//  NewTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class NewTransactionViewModel: BaseViewModel {
    
    @Published var model = TransactionModel()
    
    @Published var selectedDate: Date = .now
    @Published var amountString: String = ""
    
    @Published var showDatePicker = false
    @Published var showCategoryList = false
    
    func onAppear() {
        model.date = Utils.dateToStringShort(date: selectedDate)
    }
    
    func addNewTransaction() async -> ResponseModel {
        if model.category.isEmptyOrWhitespace() {
            return ResponseModel(.error, Messages.emptySpaces.localizedDescription)
        }
        
        //Firebase necesita guardar el valor como decimal, pero los formatos del monto en pantalla se trabajan en string:
        let amountDecimal = UtilsCurrency.convertAmountStringToDecimal(amountString)
        model.amount = amountDecimal
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await Repository().addNewDocument(self.model, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
