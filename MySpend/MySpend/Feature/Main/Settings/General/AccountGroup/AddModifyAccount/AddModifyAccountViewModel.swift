//
//  AddModifyAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Observation

@Observable
final class AddModifyAccountViewModel {
    
    var account: AccountModel
    var isDefaultSelected = false
    
    var showAlert = false
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
    }
    
    func create(with accountManager: AccountManager) async -> ResponseToast {
        if account.name.isEmptyOrWhitespace {
            return ResponseToast(.responseErrorTextFieldEmptySpace, .error)
        }
        
        return await accountManager.create(account, isDefault: isDefaultSelected)
    }
    
    func update(with accountManager: AccountManager) async -> ResponseToast {
        if account.name.isEmptyOrWhitespace {
            return ResponseToast(.responseErrorTextFieldEmptySpace, .error)
        }
        
        return await accountManager.update(account, isDefault: isDefaultSelected)
    }
    
    func delete(with accountManager: AccountManager) async -> ResponseToast {
        return await accountManager.delete(account)
    }
}
