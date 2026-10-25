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
}
