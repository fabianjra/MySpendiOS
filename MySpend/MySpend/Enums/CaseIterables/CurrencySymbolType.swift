//
//  CurrencySymbolType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/1/25.
//

enum CurrencySymbolType: String, CaseIterable, Identifiable, Codable {
    public var id: Self { self }
    
    case symbol = "Currency Symbol"
    case code = "Currency Code"
}
