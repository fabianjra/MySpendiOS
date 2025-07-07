//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

class CurrencyListViewModel: BaseViewModelFB {
    
    @Published var localeCurrency = CurrencyManager.localeCurrencyOrDefault.updateModelToUserDefaultsSelected //Get locale currency and set Selected or not, depending on UserDefaults.
    @Published var currenciesAvailables: [CurrencyModel] = []
    @Published var currencySymbolType: CurrencySymbolType = CurrencyManager.selectedCurrencySymbolType
    

    func fetchCurrencyList() {
        // Loop to know which currency is selected in UserDefaults and check it in the View.
        self.currenciesAvailables = CurrencyManager.currencyList().map { currency in
            return currency.updateModelToUserDefaultsSelected
        }
    }
    
    func updateCurrencySelected(_ model: CurrencyModel) {
        CurrencyManager.selectedCurrency = model // Update the UserDefaults
        
        self.localeCurrency = self.localeCurrency.updateModelToUserDefaultsSelected
        
        // Should modify the whole array because have to Uncheck the old checked currency and check the new one.
        self.currenciesAvailables = self.currenciesAvailables.map { currency in
            return currency.updateModelToUserDefaultsSelected
        }
    }

    func updateCurrencySymbolTypeSelected() {
        CurrencyManager.selectedCurrencySymbolType = self.currencySymbolType // Update the UserDefaults
    }
}
