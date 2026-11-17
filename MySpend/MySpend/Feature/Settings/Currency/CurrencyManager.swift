//
//  CurrencyManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

@Observable
final class CurrencyManager {
    
    static let shared = CurrencyManager()
    
    private init() {}

    
    // MARK: - USER DEFAULTS
    
    var selectedCurrency = UserDefaultsManager.currency {
        didSet { UserDefaultsManager.currency = self.selectedCurrency }
    }
    
    var selectedSymbolType = UserDefaultsManager.currencySymbolType {
        didSet { UserDefaultsManager.currencySymbolType = self.selectedSymbolType }
    }
    
    /**
     Gets the symbol type selected in the settings (from UserDefaults).
     Depending on the symbol type, it will take the `symbol` or `code` from the currency saved in the UserDefaults.
     
     It is used to show the currency symbol selected for the currency selected in any view that shows amouts (Transactions View, History, View, etc.)
     */
    var selectedSymbolOrCode: String {
        self.selectedSymbolType == .symbol ? selectedCurrency.symbol : selectedCurrency.currencyCode
    }
}

extension String {

    /**
     if there is roughly < 30 substrings to attach together, then concatenation is faster
     if there is roughly > 30 substrings to attach together, then interpolation is faster
     */
    func addCurrencySymbol(_ symbol: String) -> String {
            "\(symbol) \(self)"
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
    var amountToDecimal: Decimal? {
        guard !isEmptyOrWhiteSpace else {
            return .zero
        }

        // Siempre se usan los decimales porque es el valor que se irá a guardar a Core Data
        let formatter = CurrencyConstant.localFormatter(showCents: true)

        guard let number = formatter.number(from: self) else {
            return nil
        }

        var amount = number.decimalValue
        var roundedAmount = Decimal()

        NSDecimalRound(&roundedAmount, &amount, CurrencyConstant.fractionLength, .bankers)

        return roundedAmount
    }
}


extension Decimal {
    
    func amountToString(showCents: Bool) -> String {
        let formatter = CurrencyConstant.localFormatter(showCents: showCents)
        let decimalNumber = NSDecimalNumber(decimal: self)
        let formattedString = formatter.string(from: decimalNumber) ?? Int.zero.description
        
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

