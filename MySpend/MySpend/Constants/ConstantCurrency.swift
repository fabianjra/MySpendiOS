//
//  ConstantCurrency.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/9/24.
//

struct ConstantCurrency {
    
    static let amoutMaxLength: Int = 12
    static let fractionLength: Int = 2
    
    public enum Symbol: String {
        case dollar = "$"
        case colon = "₡"
    }
}
