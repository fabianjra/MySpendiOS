//
//  FilterTransactionsViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/8/26.
//

import Foundation

@Observable
final class FilterCenter {
    static let shared = FilterCenter()
    
    private init() {}
    
    var isFilterActive: Bool = false
    var selectedAccountsFilter = UserDefaultsManager.selectedAccountsFilter
    var showOnlyFavorites: Bool = false
    
    func restoreFilterSelectionByOptions(allAccountsAvailable allAccounts: [AccountModel]) {
        selectedAccountsFilter = Set(allAccounts)
        showOnlyFavorites = false
    }
    
    func addRemoveAccountsInUserDefaults(account: AccountModel) {
        if selectedAccountsFilter.contains(account) {
            selectedAccountsFilter.remove(account)
        } else {
            selectedAccountsFilter.insert(account)
        }
        
        UserDefaultsManager.selectedAccountsFilter = Set(selectedAccountsFilter)
    }
}
