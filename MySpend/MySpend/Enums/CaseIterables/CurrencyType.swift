//
//  CurrencyType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/1/25.
//

enum CurrencyType: String, CaseIterable, Identifiable, Hashable {
    public var id: Self { self }
    
    case symbol = "Currency Symbol"
    case code = "Currency Code"
}
