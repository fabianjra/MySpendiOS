//
//  FilterTransactionsViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/8/26.
//

//import Observation
import Foundation

@Observable
final class FilterCenter {
    static let shared = FilterCenter()
        
    var showOnlyFavorites: Bool = false
    var selectedAccountsFilter = UserDefaultsManager.selectedAccountsFilter {
        didSet {
            UserDefaultsManager.selectedAccountsFilter = selectedAccountsFilter
        }
    }
    
    // Permite que se instancie una unica vez y que no se pueda cambiar su instancia
    private init() {}

    
    func restoreFilter(allAccountsAvailable accounts: [AccountModel]) {
        selectedAccountsFilter = Set(accounts.compactMap(\.id))
        showOnlyFavorites = false
    }
    
    func toggleAccount(_ account: AccountModel) {
        if selectedAccountsFilter.contains(account.id) {
            selectedAccountsFilter.remove(account.id)
        } else {
            selectedAccountsFilter.insert(account.id)
        }
    }
}
