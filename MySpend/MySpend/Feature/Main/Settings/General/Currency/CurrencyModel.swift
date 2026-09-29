//
//  CurrencyModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

struct CurrencyModel: Identifiable, Codable, Equatable {
    var id = UUID()
    
    let countryCode: String
    let symbol: String
    let currencyCode: String
    let countryName: String
    let countryFlag: String
    
    init(countryCode: String,
         symbol: String,
         currencyCode: String,
         countryName: String,
         countryFlag: String) {
        
        self.countryCode = countryCode
        self.symbol = symbol
        self.currencyCode = currencyCode
        self.countryName = countryName
        self.countryFlag = countryFlag
    }
}
