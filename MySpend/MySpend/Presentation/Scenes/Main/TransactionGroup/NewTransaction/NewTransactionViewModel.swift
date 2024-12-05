//
//  NewTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class NewTransactionViewModel: BaseViewModel {
    
    @Published var model = TransactionModel()
    
    @Published var dateString: String = Date.now.toStringShortLocale
    @Published var amountString: String = ""
    
    @Published var showDatePicker = false
    @Published var showCategoryList = false
    
    func addNewTransaction() async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //Firebase necesita guardar el valor como decimal, pero los formatos del monto en pantalla se trabajan en string:
        let amountDecimal = amountString.convertAmountToDecimal
        model.amount = amountDecimal
        model.dateCreated = .now
        model.datemodified = .now
        
        var response = ResponseModel()
        
        await performWithLoader { currentUser in
            do {
                self.model.userId = currentUser.uid
                
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
