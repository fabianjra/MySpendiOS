//
//  CurrencyModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

struct CurrencyModel: Identifiable {
    public var id: String = UUID().uuidString
    
    let countryCode: String
    let currencySymbol: String
    let currencyCode: String
    let countryName: String
    let selected: Bool = false
}
