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
        do {
            accounts = try AccountManager(viewContext: viewContext).fetchAll()
            
            if accounts.isEmpty {
                disabled = true
                errorMessage = Errors.notFoundAccount.localizedDescription
                return
            }
            
            if accounts.count == 1 {
                showAccountTextField = false
            }
            
            if isNewModel {
                let defaultID: String = UserDefaultsManager.defaultAccountID
                if let defaultAccount = accounts.first(where: { $0.id.uuidString == defaultID }) {
                    model.account = defaultAccount
                } else {
                    guard let firstAccount = accounts.first else {
                        disabled = true
                        errorMessage = Errors.notFoundAccount.localizedDescription
                        return
                    }
                    
                    model.account = firstAccount
                }
            }
        } catch {
            Logger.exception(error, type: .CoreData)
            errorMessage = error.localizedDescription
        }
    }
    
    func addNew() -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        let response = validateAccountType()
        if response.status.isError {
            return response
        }
        
        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        
        do {
            try TransactionManager(viewContext: viewContext).create(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify() -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        let response = validateAccountType()
        if response.status.isError {
            return response
        }
        
        var modelMutated = model
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
    
    private func validateAccountType() -> ResponseModel {
        let accountType = model.account.type
        let categoryType = model.category.type
        
        if accountType != .general {
            if accountType == .expenses && categoryType == .income {
                return ResponseModel(.error, Errors.accountTypeNotMatchCategoryType(model.account.name, accountType.rawValue).localizedDescription)
            } else if accountType == .incomes && categoryType == .expense {
                return ResponseModel(.error, Errors.accountTypeNotMatchCategoryType(model.account.name, accountType.rawValue).localizedDescription)
            }
        }
        
        return ResponseModel(.successful)
    }
}
