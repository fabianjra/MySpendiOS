//
//  String+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import UIKit
import SwiftUI

extension String {
    
    // MARK: - CURRENCY:
    
    /**
     if there is roughly < 30 substrings to attach together, then concatenation is faster
     if there is roughly > 30 substrings to attach together, then interpolation is faster
     */
    public var addCurrencySymbol: String {
        return "\(CurrencyManager.selectedSymbolOrCode) \(self)" //Interpolation.
    }
    
    /**
     Converts a string representing a monetary value into a `Decimal` value based on the current locale's number format.

     This method uses a custom `NumberFormatter` to parse the input string. If the string is successfully converted into a `Decimal`, that value is returned. If the conversion fails, the method returns `0`.

     **Example:**
     ```swift
     let decimalValue = Utils.amountStringToDecimal("1,234.56")
     print(decimalValue) // Prints "1234.56"
     
     let withoutValue = Utils.amountStringToDecimal("1234")
     print(withoutValue) // Prints "1234"
     
     let invalidValue = Utils.amountStringToDecimal("invalid")
     print(invalidValue) // Prints "0"
     ```
     
     - Parameters:
        - amount: A String representing the monetary value to be converted to Decimal. The string should be formatted according to the locale's decimal separator and thousands separator
     
     - Returns: A Decimal representation of the given string, or 0 if the string cannot be converted

     - Authors: Fabian Rodriguez

     - Date: September 2024
     */
    var convertAmountToDecimal: Decimal? {
        guard !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .zero
        }

        let formatter = UtilsTransactions.localFormatter(showCents: UserDefaultsManager.showCents)

        guard let number = formatter.number(from: self) else {
            return nil
        }

        var amount = number.decimalValue
        var roundedAmount = Decimal()

        NSDecimalRound(&roundedAmount, &amount, CurrencyManager.fractionLength, .bankers)

        return roundedAmount
    }
    
    
    // MARK: - TEXT
    
    /**
     Validate if a String is empty incluiding white spaces.
     
     **Example:**
     ```swift
     if textField.text?.isEmptyOrWhitespace == true {
         printContent("Is empty")
         return
     }
     ```
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Feb 2023
     */
    public var isEmptyOrWhitespace: Bool {
        if(self.isEmpty) {
            return true
        }
        
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
