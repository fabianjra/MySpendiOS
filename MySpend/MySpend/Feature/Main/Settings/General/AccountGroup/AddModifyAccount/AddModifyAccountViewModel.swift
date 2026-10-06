//
//  AddModifyAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

final class AddModifyAccountViewModel: BaseViewModel {
    
    @Published var account: AccountModel
    @Published var isDefaultSelected = false
    
    @Published var showAlert = false
    var isNewAccount: Bool = true
    
    init(_ account: AccountModel? = nil) {
        
        // If model exists, then it's a Modify action.
        if let accountLoaded = account {
            self.account = accountLoaded
            self.isNewAccount = false
            
            if UserDefaultsManager.defaultAccountID == accountLoaded.id.uuidString {
                self.isDefaultSelected = true
            }
        } else {
            self.account = AccountModel()
        }
        
        super.init()
    }
    
    func addNew(accountManager: AccountManager) async -> ResponseModel {
        if account.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        do {
            try await AccountCoreDataManager(viewContext).create(account)
            accountManager.selectedAccountsToFilterByID.insert(account.id)
            
            if isDefaultSelected {
                accountManager.setDefaultAccount(by: account)
            }
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify() async -> ResponseModel {
        if account.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        do {
            try await AccountCoreDataManager(viewContext).update(account)
            
            if isDefaultSelected {
                UserDefaultsManager.defaultAccountID = account.id.uuidString
            } else {
                if UserDefaultsManager.defaultAccountID == account.id.uuidString {
                    UserDefaultsManager.defaultAccountID = ""
                }
            }
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete() async -> ResponseModel {
        do {
            try await AccountCoreDataManager(viewContext).delete(account)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
