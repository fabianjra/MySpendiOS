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
    
    func addNewTransaction(_ categoryType: CategoryType) -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.category.type = categoryType
        modelMutated.amount = amountString.convertAmountToDecimal
        
        do {
            try TransactionManager(viewContext: viewContext).create(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modifyTransaction(_ categoryType: CategoryType) -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.category.type = categoryType
        modelMutated.amount = amountString.convertAmountToDecimal
        
        do {
            try TransactionManager(viewContext: viewContext).update(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteTransaction() -> ResponseModel {
        do {
            try TransactionManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
