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
    
    var greeting: LocalizedStringResource {
        let hour = Calendar.current.component(.hour, from: .now)
        
        switch hour {
        case 5..<12: return .greetGoodMorning
        case 12..<18: return .greetGoodAfternoon
        default: return .greetGoodEvening
        }
    }
}
