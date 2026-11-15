//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Observation

@Observable
final class CurrencyViewModel {
    
    var localeCurrency: CurrencyModel
    var availabelsCurrencies: [CurrencyModel]
    var commonCurrencies: [CurrencyModel]
    
    init() {
        let localeCurrency = CurrencyManager.localeCurrency
        let availableCurrencies = CurrencyManager.currencyList
        
        self.localeCurrency = localeCurrency
        self.availabelsCurrencies = availableCurrencies
        self.commonCurrencies = CurrencyManager.commonCurrencies(from: availableCurrencies,
                                                                 localCurrency: localeCurrency)
    }
}
