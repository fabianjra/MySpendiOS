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
    @Published var currencySymbolType: CurrencySymbolType = UserDefaultsCurrency.selectedCurrencySymbolTypeUserDefaults
    

    func fetchCurrencyList() {
        self.localeCurrency = self.localeCurrency.updateModelToUserDefaultsSelected()
        
        // Utilizado para saber cual es el Currency que esta seleccionado y marcarlo con Check en el View.
        self.currenciesAvailables = CurrencyManager.currencyList().map { currency in
            return currency.updateModelToUserDefaultsSelected()
        }
    }
    
    func updateCurrencySelected(_ model: CurrencyModel) {
        UserDefaultsCurrency.selectedCurrencyUserDefaults = model // Update the UserDefaults
        
        self.localeCurrency = self.localeCurrency.updateModelToUserDefaultsSelected()
        
        // Se debe modificar todo el array porque se debe quitar la seleccion del que haya sido seleccionado anteriormente.
        self.currenciesAvailables = self.currenciesAvailables.map { currency in
            return currency.updateModelToUserDefaultsSelected()
        }
    }

    func updateCurrencySymbolTypeSelected() {
        UserDefaultsCurrency.selectedCurrencySymbolTypeUserDefaults = self.currencySymbolType // Update the UserDefaults
    }
}
