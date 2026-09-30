//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Observation

@Observable
final class CurrencyViewModel {
    
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
    
    var localeCurrency: CurrencyModel
    var availabelsCurrencies: [CurrencyModel]
    var commonCurrencies: [CurrencyModel]
    
    init() {
        let localeCurrency = CurrencyManager.localeCurrencyOrDefault
        let availableCurrencies = CurrencyManager.currencyList()
        
        self.localeCurrency = localeCurrency
        self.availabelsCurrencies = availableCurrencies
        self.commonCurrencies = CurrencyManager.commonCurrencies(from: availableCurrencies,
                                                                 localCurrency: localeCurrency)
    }
}
