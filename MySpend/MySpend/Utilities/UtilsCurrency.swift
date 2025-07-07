//
//  UtilsCurrency.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/24.
//

import Foundation

public struct UtilsCurrency {

    /**
     Returns a localized `NumberFormatter` configured for decimal numbers based on the current locale.
     
     This formatter can be used to format numbers that include a fixed number of fractional digits (like currency).
     
     **Example:**
     ```swift
     let formatter = UtilCurrency.getLocalFormatter
     let formattedNumber = formatter.number(from: "1234.567")
     print(formattedNumber) // Prints "1234.57" or "1234,57" depending on locale
     ```
     
     - Returns: A NumberFormatter configured with locale settings, decimal number style, and rounding mode
     
     - Authors: Fabian Rodriguez
     
     - Date: Sepember 2024
     */
    public static var getLocalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale.current
        //formatter.maximumIntegerDigits = CurrencyManager.amoutMaxLength
        formatter.minimumFractionDigits = CurrencyManager.fractionLength
        formatter.maximumFractionDigits = CurrencyManager.fractionLength
        
        /*
         numberStyle: Define el estilo general del formateo numérico.
         .decimal: Formato decimal estándar (ejemplo: 1234.56).
         .currency: Formato monetario (ejemplo: $1,234.56).
         .percent: Formato de porcentaje (ejemplo: 12.34%).
         .scientific: Notación científica (ejemplo: 1.23E3).
         .spellOut: Convierte el número en palabras (ejemplo: "mil doscientos treinta y cuatro").
         */
        //formatter.numberStyle = .decimal
        
        
        // **********************
        // Optionals parameters:
        // **********************
        
        //formateará el número con separadores de miles (ejemplo: 1,234.56)
        formatter.usesGroupingSeparator = true
        
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
    
    static func makeDecimal(_ value: Decimal) -> NSDecimalNumber {
        let number = NSDecimalNumber(decimal: value)

        // Ejemplo de validación de NaN y rango
        guard number != .notANumber else {
            return 0
        }

        // Fuerza dos decimales con redondeo bancario
        let handler = NSDecimalNumberHandler (
            roundingMode: .bankers,
            scale: 2,
            raiseOnExactness: false,
            raiseOnOverflow: true,
            raiseOnUnderflow: true,
            raiseOnDivideByZero: true
        )
        
        return number.rounding(accordingToBehavior: handler)
    }
}

// MARK: TOTAL BALANCE CALCULATIONS

extension UtilsCurrency {
    typealias groupedTransactions = [(category: CategoryModel, totalAmount: Decimal)]
    
    /**
     Esta función filtra las transacciones por CategoryType, sumando los ingresos (income) y los gastos (expense).
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
