//
//  AddModifyTransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class AddModifyTransactionViewModel: BaseViewModel {
    
    @Published var accounts: [AccountModel] = []
    
    @Published var amountString: String = ""

    @Published var showDatePicker = false
    @Published var showCategoryList = false
    @Published var showAccoountList = false
    @Published var showAccountTextField = true
    @Published var showAlert = false

    @Published var model: TransactionModel
    var isNewModel: Bool = true
    let notesId = "notes"
    
    init(_ model: TransactionModel? = nil, selectedDate: Date? = nil) {
        
        // If model exists, then is a Modify action.
        if let modelLoaded = model {
            self.model = modelLoaded
            self.isNewModel = false
            self.amountString = modelLoaded.amount.convertAmountDecimalToString
        } else {
            self.model = TransactionModel(dateTransaction: selectedDate ?? .now)
        }
        
        super.init(viewContext: CoreDataUtilities.getViewContext())
    }
    
    func fetchAccounts() {
        
        let defaultID: String = UserDefaultsManager.defaultAccountID
        
        do {
            accounts = try AccountManager(viewContext: viewContext).fetchAll()
            
            if accounts.isEmpty {
                disabled = true
                errorMessage = Errors.notFoundAccount.localizedDescription
                return
            }
            
            // Select default account or the first account existing
            if let defaultAccount = accounts.first(where: { $0.id.uuidString == defaultID }) {
                showAccountTextField = false
                model.account = defaultAccount
            } else {
                guard let firstAccount = accounts.first else {
                    disabled = true
                    errorMessage = Errors.notFoundAccount.localizedDescription
                    return
                }
                
                model.account = firstAccount
            }
        } catch {
            Logger.exception(error, type: .CoreData)
            errorMessage = error.localizedDescription
        }
    }
    
    func addNew(_ categoryType: CategoryType) -> ResponseModel {
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
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify(_ categoryType: CategoryType) -> ResponseModel {
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
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete() -> ResponseModel {
        do {
            try TransactionManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
