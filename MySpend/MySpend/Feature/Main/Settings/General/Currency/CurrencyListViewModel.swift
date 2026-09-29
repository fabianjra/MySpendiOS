//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

@Observable
final class CurrencyListViewModel {
    
    var localeCurrency = CurrencyManager.localeCurrencyOrDefault
    var currenciesAvailables = CurrencyManager.currencyList()
    
    var selectedCurrency = UserDefaultsManager.currency {
        didSet {
            UserDefaultsManager.currency = self.selectedCurrency
        }
    }
    
    var selectedCurrencySymbolType: CurrencySymbolType = UserDefaultsManager.currencySymbolType {
        didSet {
            UserDefaultsManager.currencySymbolType = self.selectedCurrencySymbolType
        }
    }
}
