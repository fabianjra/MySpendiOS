//
//  CurrencySymbolType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/1/25.
//

enum CurrencySymbolType: String, CaseIterable, Identifiable, Codable, Localizable {
    public var id: Self { self }
    
    case symbol
    case code
}
