//
//  AddModifyTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class AddModifyTransactionViewModel: BaseViewModel {
    
    @Published var amountString: String = ""

    @Published var showDatePicker = false
    @Published var showCategoryList = false
    @Published var showAlert = false

    @Published var model: TransactionModel
    var isNewTransaction: Bool = true
    let notesId = "notes"
    
    init(_ model: TransactionModel? = nil, selectedDate: Date? = nil) {
        
        // If model exists, then is a Modify action.
        if let modelLoaded = model {
            self.model = modelLoaded
            self.isNewTransaction = false
            self.amountString = modelLoaded.amount.convertAmountDecimalToString
        } else {
            self.model = TransactionModel(dateTransaction: selectedDate ?? .now)
        }
        
        super.init(viewContext: CoreDataUtilities.getViewContext())
    }
    
    func addNewTransaction() -> ResponseModelFB {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        
        do {
            try TransactionManager(viewContext: viewContext).create(modelMutated)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func modifyTransaction() -> ResponseModelFB {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        
        do {
            try TransactionManager(viewContext: viewContext).update(modelMutated)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func deleteTransaction() -> ResponseModelFB {
        do {
            try TransactionManager(viewContext: viewContext).delete(model)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
}
