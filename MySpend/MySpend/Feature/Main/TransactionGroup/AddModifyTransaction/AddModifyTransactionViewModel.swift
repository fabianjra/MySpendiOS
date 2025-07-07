//
//  AddModifyTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class AddModifyTransactionViewModel: BaseViewModel {
    
    @Published var dateString: String = Date.now.toStringShortLocale
    @Published var amountString: String = ""
    
    @Published var showDatePicker = false
    @Published var showCategoryList = false
    @Published var showAlert = false
    
    let notesId = "notes"
    
    func onAppear(_ model: TransactionModel, selectedDate: Date, isNewTransaction: Bool) {
        if isNewTransaction {
            dateString = selectedDate.toStringShortLocale
        } else {
            dateString = model.dateTransaction.toStringShortLocale
            amountString = model.amount.convertAmountDecimalToString
        }
    }
    
    func addNewTransaction(_ model: TransactionModel, selectedDate: Date) -> ResponseModelFB {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //TODO: Cambiar para que mas bien se use el selectedDate con la de Model:
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.dateTransaction = selectedDate
        
        do {
            try TransactionManager(viewContext: viewContext).create(modelMutated)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func modifyTransaction(_ model: TransactionModel, selectedDate: Date) -> ResponseModelFB {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //TODO: Cambiar para que mas bien se use el selectedDate con la de Model:
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.dateTransaction = selectedDate
        modelMutated.dateModified = .now
        
        do {
            try TransactionManager(viewContext: viewContext).update(modelMutated)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func deleteTransaction(_ model: TransactionModel) -> ResponseModelFB {
        do {
            try TransactionManager(viewContext: viewContext).delete(model)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
}
