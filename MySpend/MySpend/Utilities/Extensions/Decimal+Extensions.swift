//
//  Decimal+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

extension Decimal {
    
    public var convertAmountDecimalToString: String {
        let formatter = UtilsCurrency.getLocalFormatter
        let decimalNumber = NSDecimalNumber(decimal: self)
        let formattedString = formatter.string(from: decimalNumber) ?? CurrencyManager.zeroAmoutString
        
        return formattedString
    }
}
