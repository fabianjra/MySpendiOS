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
    @Published var favorite: Bool = false

    var showAccountTextField = true
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
            self.favorite = modelLoaded.favorite
        } else {
            self.model = TransactionModel(dateTransaction: selectedDate ?? .now)
        }
        
        super.init()
    }
    
    func fetchAccounts() async {
        do {
            accounts = try await AccountManager(viewContext).fetchAll()
            
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
    
    func addNew() async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }

        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.dateTransaction = UtilsDate.normalizeTransactionDate(model.dateTransaction)
        modelMutated.favorite = favorite
        
        do {
            try await TransactionManager(viewContext).create(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify() async -> ResponseModel {
        if model.category.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }

        var modelMutated = model
        modelMutated.amount = amountString.convertAmountToDecimal
        modelMutated.favorite = favorite
        
        do {
            try await TransactionManager(viewContext).update(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete() async -> ResponseModel {
        do {
            try await TransactionManager(viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
