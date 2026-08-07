//
//  FilterTransactionsViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/8/26.
//

import Observation

@Observable
final class FilterCenter {
    static let shared = FilterCenter()
        
    var isFilterActive: Bool = false
    var showOnlyFavorites: Bool = false
    
    var selectedAccountsFilter = UserDefaultsManager.selectedAccountsFilter {
        didSet {
            UserDefaultsManager.selectedAccountsFilter = selectedAccountsFilter
        }
    }
    
    // Permite que se instancie una unica vez y que no se pueda cambiar su instancia
    private init() {}

    
    func restoreFilterSelectionByOptions(allAccountsAvailable allAccounts: [AccountModel]) {
        selectedAccountsFilter = Set(allAccounts)
        showOnlyFavorites = false
    }
    
    func toggleAccount(_ account: AccountModel) {
        if selectedAccountsFilter.contains(account) {
            selectedAccountsFilter.remove(account)
        } else {
            selectedAccountsFilter.insert(account)
        }
    }
}
