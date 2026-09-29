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
    
    var selectedCurrency = CurrencyManager.selectedCurrency {
        didSet {
            CurrencyManager.selectedCurrency = self.selectedCurrency
        }
    }
    
    var currencySymbolType: CurrencySymbolType = CurrencyManager.selectedCurrencySymbolType {
        didSet {
            CurrencyManager.selectedCurrencySymbolType = self.currencySymbolType
        }
    }
}
