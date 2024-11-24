//
//  UtilsCurrency.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/24.
//

import Foundation

public struct UtilsCurrency {
    
//    public static func convertAmountDecimalToString(_ amount: Decimal) -> String {
//        let formatter = getLocalFormatter()
//        let decimalNumber = NSDecimalNumber(decimal: amount)
//        let formattedString = formatter.string(from: decimalNumber) ?? ConstantCurrency.zeroAmoutString
//        
//        return formattedString
//    }
    
    public static func getLocalDecimalSeparator() -> String {
        let formatter = getLocalFormatter()
        return formatter.decimalSeparator ?? ConstantCurrency.defaultDecimalSeparator
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
     
     - Parameter amount: A String representing the monetary value to be converted to Decimal. The string should be formatted according to the locale's decimal separator and thousands separator

     - Returns: A Decimal representation of the given string, or 0 if the string cannot be converted

     - Authors: Fabian Rodriguez

     - Date: September 2024
     */
    public static func convertAmountStringToDecimal(_ amount: String) -> Decimal {
        let formatter = UtilsCurrency.getLocalFormatter()
        
        if let amountCasted = formatter.number(from: amount) {
            var amountDecimal = amountCasted.decimalValue
            
            // Redondear a 2 decimales
            var roundedDecimal = Decimal()
            
            NSDecimalRound(&roundedDecimal,
                           &amountDecimal,
                           ConstantCurrency.fractionLength,
                           .bankers)
            
            return roundedDecimal
        } else {
            return .zero
        }
    }
    
    /**
     Returns a localized `NumberFormatter` configured for decimal numbers based on the current locale.
     
     This formatter can be used to format numbers that include a fixed number of fractional digits (like currency).
     
     **Example:**
     ```swift
     let formatter = UtilCurrency.getLocalFormatter()
     let formattedNumber = formatter.number(from: "1234.567")
     print(formattedNumber) // Prints "1234.57" or "1234,57" depending on locale
     ```
     
     - Returns: A NumberFormatter configured with locale settings, decimal number style, and rounding mode
     
     - Authors: Fabian Rodriguez
     
     - Date: Sepember 2024
     */
    public static func getLocalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale.current
        formatter.maximumIntegerDigits = ConstantCurrency.amoutMaxLength
        formatter.minimumFractionDigits = ConstantCurrency.fractionLength
        formatter.maximumFractionDigits = ConstantCurrency.fractionLength
        
        /*
         numberStyle: Define el estilo general del formateo numérico.
         .decimal: Formato decimal estándar (ejemplo: 1234.56).
         .currency: Formato monetario (ejemplo: $1,234.56).
         .percent: Formato de porcentaje (ejemplo: 12.34%).
         .scientific: Notación científica (ejemplo: 1.23E3).
         .spellOut: Convierte el número en palabras (ejemplo: "mil doscientos treinta y cuatro").
         */
        formatter.numberStyle = .decimal
        
        
        // **********************
        // Optionals parameters:
        // **********************
        
        //formateará el número con separadores de miles (ejemplo: 1,234.56)
        ///formatter.usesGroupingSeparator = true
        
        /*
         roundingMode: Define cómo redondear los números.
         .up: Siempre redondea hacia arriba.
         .down: Siempre redondea hacia abajo.
         .halfUp: Redondea al número más cercano, y si es exactamente a la mitad, redondea hacia arriba (esto es lo estándar en la mayoría de los casos).
         .halfDown: Redondea hacia abajo si está en la mitad.
         .ceiling: Siempre redondea hacia el infinito positivo.
         .floor: Siempre redondea hacia el infinito negativo.
         */
        ///formatter.roundingMode = .halfUp
        
        /*
         currencySymbol y currencyCode: Personaliza el símbolo y el código de la moneda.
         Ejemplo: formatter.currencySymbol = "€" o formatter.currencyCode = "EUR".
         */
        ///formatter.currencySymbol = "$"
        ///formatter.currencyCode = "USD"
        
        /*
         notANumberSymbol: Define lo que se mostrará si el número es un valor no numérico (NaN).
         Ejemplo: formatter.notANumberSymbol = "NaN"
         */
        ///formatter.notANumberSymbol = "NaN"
        
        /*
         positivePrefix y negativePrefix: Establecen un prefijo para números positivos o negativos.
         Ejemplo: formatter.positivePrefix = "+" para que los números positivos tengan un "+" al principio.
         */
        ///formatter.positivePrefix = "+"
        
        return formatter
    }
    
    /**
     Rounds the input string to two decimal places if the input has more than two decimal digits. If the input has two or fewer decimal places, it returns the original input.

     This method first identifies the decimal separator based on the user's locale. It then checks if the decimal part has more than two digits. If so, it rounds the number using the `.halfUp` rounding mode.

     **Example:**
     ```swift
     let roundedValue = Utils.roundIfMoreThanTwoDecimals("1234.5678")
     print(roundedValue) // Prints "1234.57"
     
     let originalValue = Utils.roundIfMoreThanTwoDecimals("1234.56")
     print(originalValue) // Prints "1234.56"
     ```
     
     - Parameter input: A String representing the number to check and potentially round

     - Returns: An optional String? which is the original input if it has two or fewer decimals, or the rounded number if it has more than two decimals

     - Authors: Fabian Rodriguez
     
     - Date: September 2024
     */
    private static func roundIfMoreThanTwoDecimals(_ input: String) -> String? {
        // 1. Crear un NumberFormatter para identificar el separador decimal
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        // 2. Separar la parte entera de la parte decimal
        let components = input.split(separator: formatter.decimalSeparator.first ?? ".")
        
        // 3. Si tiene una parte decimal, verificar cuántos dígitos tiene
        if components.count == 2 {
            let decimals = components[1]
            if decimals.count > 2 {
                // 4. Aplicar redondeo si tiene más de 2 dígitos decimales
                formatter.maximumFractionDigits = 2
                formatter.roundingMode = .halfUp
                if let number = formatter.number(from: input) {
                    return formatter.string(from: number)
                }
            } else {
                // 5. Si tiene exactamente 2 o menos decimales, devolver el número original
                return input
            }
        }
        
        // 6. Si no tiene decimales o ya está en el formato adecuado
        return input
    }
}

// MARK: TOTAL BALANCE CALCULATIONS

extension UtilsCurrency {
    typealias groupedTransactions = [(category: CategoryModel, totalAmount: Decimal)]
    
    /**
     Esta función filtra las transacciones por transactionType, sumando los ingresos (income) y los gastos (expense).
     Luego, calcula el balance final restando los gastos a los ingresos y formatea el balance.
     */
    static func calculateGroupedTransactions(_ transactions: [TransactionModel]) -> groupedTransactions {
        let grouped = Dictionary(grouping: transactions) { $0.category.id }
        
        let groupedTransactions = grouped.compactMap { (categoryId, transactions) -> (CategoryModel, Decimal)? in
            guard let firstTransaction = transactions.first else
            {
                return nil
            }
            
            let totalAmount = transactions.reduce(Decimal.zero) { $0 + $1.amount }
            return (firstTransaction.category, totalAmount)
        }
        
        return groupedTransactions
    }
}
