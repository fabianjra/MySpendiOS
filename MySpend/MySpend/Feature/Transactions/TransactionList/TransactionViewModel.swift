//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

@Observable
final class TransactionViewModel {
    
    var userName = UserDefaultsManager.userName
    
    var searchText = ""
    var showSearchView = false
    
    var selectedDate: Date = .now
    
    var showCreateTransaction = false
    var navigateToSettings = false
    var navigateToHistory: Bool = false
    
    var showFilters = false
}
