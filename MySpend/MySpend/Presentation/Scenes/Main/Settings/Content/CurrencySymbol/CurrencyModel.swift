//
//  CurrencyModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

struct CurrencyModel: Identifiable {
    public var id: String = UUID().uuidString
    
    var countryCode: String
    var symbol: String
    var currencyCode: String
    var countryName: String
    var selected: Bool = false
}
