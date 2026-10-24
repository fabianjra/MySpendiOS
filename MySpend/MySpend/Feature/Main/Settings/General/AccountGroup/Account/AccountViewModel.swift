//
//  AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Observation

@Observable
final class AccountViewModel {
    
    var selectedAccounts = Set<AccountModel>()
    
    var showCreateAccount = false
    
    var showUpdateAccount = false
    var accountToUpdate = AccountModel()
    
    var showAlertDelete = false
    var accountToDelete: AccountModel?

    func toggleAccountSelection(_ account: AccountModel) {
        if selectedAccounts.contains(account) {
            selectedAccounts.remove(account)
        } else {
            selectedAccounts.insert(account)
        }
    }
}
