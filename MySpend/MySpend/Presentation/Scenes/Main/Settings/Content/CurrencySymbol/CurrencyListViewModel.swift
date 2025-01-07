//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

class CurrencyListViewModel: BaseViewModel {
    
    @Published var localeCurrency: CurrencyModel?
    @Published var currenciesAvailables: [CurrencyModel] = []
    @Published var useCurrencySymbol: Bool = true
    
    func fetchCurrencyList() {
        localeCurrency = CurrencyManager().localeCurrency
        currenciesAvailables = CurrencyManager.currencyList()
    }
    
    func selectCurrencySymbol(_ currencySymbol: String) {
        CurrencyManager.selectedCurrencySymbol = currencySymbol
    }
    
    func resetCurrencySymbol() {
        CurrencyManager.removeSelectedCurrencySymbol
    }
}
