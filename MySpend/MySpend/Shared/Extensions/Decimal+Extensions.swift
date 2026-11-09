//
//  Decimal+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

extension Decimal {
    
    func amountToString(showCents: Bool) -> String {
        let formatter = UtilsTransactions.localFormatter(showCents: showCents)
        let decimalNumber = NSDecimalNumber(decimal: self)
        let formattedString = formatter.string(from: decimalNumber) ?? CurrencyManager.zeroAmoutString
        
        return formattedString
    }
    
    /**
     Converts the Decimal value into an NSDecimalNumber for Core Data persistence.
     
     Rounds the value to two decimal places using banker's rounding
     (round half to even) to ensure consistent monetary precision.
     
     - Returns: An NSDecimalNumber rounded to two decimal places.
     - Throws: DecimalConversionError.invalidAmount if the value is NaN.
     */
    func toNSDecimalNumber() throws -> NSDecimalNumber {
        var amount = self
        var roundedAmount = Decimal.zero
        
        NSDecimalRound(&roundedAmount, &amount, 2, .bankers)
        
        let number = NSDecimalNumber(decimal: roundedAmount)
        
        guard number != .notANumber else {
            throw DecimalConversionError.invalidAmount
        }
        
        return number
    }
}

enum DecimalConversionError: Error {
    case invalidAmount
}
