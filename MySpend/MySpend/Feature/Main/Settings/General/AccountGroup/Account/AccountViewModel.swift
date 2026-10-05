//
//  AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Observation

@Observable
final class AccountViewModel {
    
    var showNewItemModal = false
    var showAlertDelete = false

    var selectedAccounts = Set<AccountModel>()
    var accountToDelete: AccountModel?
    var accountToUpdate: AccountModel?

    func toggleAccountSelection(_ account: AccountModel) {
        if selectedAccounts.contains(account) {
            selectedAccounts.remove(account)
        } else {
            selectedAccounts.insert(account)
        }
    }
}
