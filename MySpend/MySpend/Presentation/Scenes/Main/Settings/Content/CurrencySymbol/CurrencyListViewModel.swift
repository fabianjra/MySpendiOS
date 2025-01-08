//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

class CurrencyListViewModel: BaseViewModel {
    
    @Published var localeCurrency = CurrencyManager.localeCurrencyOrDefault
    @Published var currenciesAvailables: [CurrencyModel] = []
    @Published var currencySymbolType: CurrencySymbolType = .symbol
    
    private var selectedCurrency: CurrencyModel {
        return CurrencyManager.selectedCurrencyUserDefaults
    }
    
    private var getCurrencySymbolType: CurrencySymbolType {
        return CurrencyManager.selectedCurrencySymbolTypeUserDefaults
    }
    
    func loadCurrencySymbolType() {
        currencySymbolType = getCurrencySymbolType
    }
    
    func fetchCurrencyList() {
        localeCurrency = localeCurrency.updateModelToSelected(withCountryCode: selectedCurrency.countryCode)
        
        currenciesAvailables = CurrencyManager.currencyList().map { currency in
            return currency.updateModelToSelected(withCountryCode: selectedCurrency.countryCode)
        }
    }
    
    func selectCurrency(_ model: CurrencyModel) {
        CurrencyManager.selectedCurrencyUserDefaults = model // Update the UserDefaults
        
        currenciesAvailables = currenciesAvailables.map { currency in
            return currency.updateModelToSelected(withCountryCode: selectedCurrency.countryCode)
        }
        
        localeCurrency = localeCurrency.updateModelToSelected(withCountryCode: selectedCurrency.countryCode)
    }

    func resetCurrency() {
        CurrencyManager.removeSelectedCurrencyUserDefaults
        fetchCurrencyList()
    }
    
    func updateCurrencySymbolType() {
        CurrencyManager.selectedCurrencySymbolTypeUserDefaults = self.currencySymbolType // Update the UserDefaults
    }
}
