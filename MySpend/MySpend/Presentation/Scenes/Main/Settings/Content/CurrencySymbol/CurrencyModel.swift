//
//  CurrencyModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

struct CurrencyModel: Identifiable, Codable {
    let id: String
    
    let countryCode: String
    let symbol: String
    let currencyCode: String
    let countryName: String
    
    let selected: Bool
    
    init(countryCode: String,
         symbol: String,
         currencyCode: String,
         countryName: String,
         selected: Bool = false) {
        
        self.id = UUID().uuidString
        self.countryCode = countryCode
        self.symbol = symbol
        self.currencyCode = currencyCode
        self.countryName = countryName
        self.selected = selected
    }
    
    var updateModelToUserDefaultsSelected: CurrencyModel {
        return CurrencyModel(countryCode: self.countryCode,
                             symbol: self.symbol,
                             currencyCode: self.currencyCode,
                             countryName: self.countryName,
                             selected: UserDefaultsManager.currency.countryCode == self.countryCode
        )
    }
}
