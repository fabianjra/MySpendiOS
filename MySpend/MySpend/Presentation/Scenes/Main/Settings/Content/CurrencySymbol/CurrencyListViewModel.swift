//
//  CurrencyListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

class CurrencyListViewModel: BaseViewModel {
    
    @Published var currencies: [CurrencyModel] = []
    @Published var useCurrencyCode: Bool = false
    
    func fetchCurrencyList() {
        currencies = CurrencyManager.currencyList(useCurrencyCode: useCurrencyCode)
    }
}
