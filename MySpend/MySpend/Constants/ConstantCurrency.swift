//
//  ConstantCurrency.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/9/24.
//

public struct ConstantCurrency {
    
    public static let amoutMaxLength: Int = 12
    public static let fractionLength: Int = 2
    public static let zeroAmoutString: String = "0.00"
    public static let defaultDecimalSeparator: String = "."
    
    public enum Symbol: String {
        case dollar = "$"
        case colon = "₡"
    }
}
