//
//  UtilsTransactions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

extension Array where Element == TransactionModel {
    
    /**
     Example:
     
     ```
     let transactions = manager.transactions
                        .filteredTransactions(by: selectedInterval, selectedDate: selectedDate)
                        .sortedTransactions(by: sortSelection)
     ```
     */
    func filteredTransactions(by interval: DateTimeInterval, selectedDate: Date, calendar: Calendar = .current) -> [TransactionModel] {
        
        guard let dateInterval = calendar.dateInterval(of: interval.componentType,
                                                       for: selectedDate) else {
            return []
        }
        
        return filter {
            dateInterval.contains($0.dateTransaction)
        }
    }
    
    func sortedTransactions(by sort: TransactionSortConfiguration) -> [TransactionModel] {
        switch sort.sortBy {
            
        case .dateTransaction:
            return sorted {
                sort.order == .ascending
                ? $0.dateTransaction > $1.dateTransaction
                : $0.dateTransaction < $1.dateTransaction
            }
            
            
        case .amount:
            return sorted {
                sort.order == .ascending
                ? $0.amount > $1.amount
                : $0.amount < $1.amount
            }
            
        case .title:
            return sorted {
                let firstTitle = $0.notes.isEmptyOrWhitespace ? $0.category.name : $0.notes
                let secondTitle = $1.notes.isEmptyOrWhitespace ? $1.category.name : $1.notes
                
                let comparison = firstTitle.localizedStandardCompare(secondTitle)

                return sort.order == .ascending
                    ? comparison == .orderedAscending
                    : comparison == .orderedDescending
            }
            
        }
    }
}


struct UtilsTransactions {
    
    typealias groupedTransactions = [(category: CategoryModel, totalAmount: Decimal)]

    /**
     Groups transactions by category and separates them into income and expense groups.

     Calculates the total amount for each category and sorts both groups by total amount in descending order.
     */
    static func groupTransactionsByType(_ transactions: [TransactionModel]) -> (incomes: groupedTransactions, expenses: groupedTransactions) {

        let grouped = Dictionary(grouping: transactions, by: { $0.category.id })

        var incomes: groupedTransactions = []
        var expenses: groupedTransactions = []

        for (_, categoryTransactions) in grouped {
            guard let firstTransaction = categoryTransactions.first else {
                continue
            }

            let category = firstTransaction.category

            let totalAmount = categoryTransactions.reduce(Decimal.zero) { $0 + $1.amount }

            switch category.type {
                
            case .income:
                incomes.append((category, totalAmount))

            case .expense:
                expenses.append((category, totalAmount))
            }
        }

        incomes.sort { $0.totalAmount > $1.totalAmount }
        expenses.sort { $0.totalAmount > $1.totalAmount }

        return (incomes, expenses)
    }
    
    
    typealias DailyGroupedTransactions = [(date: Date, transactions: [TransactionModel])]
    
    /**
     Groups transactions by calendar day, ignoring the time component.
     
     Preserves the original order of transactions within each day
     and sorts the date sections from newest to oldest.
     
     - Parameters:
     - transactions: The transactions to group.
     - calendar: The calendar used to determine each transaction's day.
     - Returns: Daily transaction groups sorted by date descending.
     */
    static func groupTransactionsByDate(_ transactions: [TransactionModel], calendar: Calendar = .current) -> DailyGroupedTransactions {
        
        let grouped = Dictionary(grouping: transactions) {
            calendar.startOfDay(for: $0.dateTransaction)
        }
        
        return grouped.map { (date: $0.key, transactions: $0.value) }.sorted { $0.date > $1.date }
    }
    
    
    /**
     ¿Filtro activo?
         ↓
     ¿Ninguna cuenta? → "None"
         ↓
     ¿Todas? → "All"
         ↓
     Entonces → nombres de las seleccionadas
     */
    static func filteredAccountsDescription(accounts: [AccountModel], selectedAccountsToFilter: Set<UUID>, isFilterActive: Bool) -> LocalizedStringResource? {
        
        guard accounts.count > 1, isFilterActive else {
            return nil
        }
        
        if selectedAccountsToFilter.isEmpty {
            return .filterAccountNoneTitle
        }
        
        if selectedAccountsToFilter.count == accounts.count {
            return .filterAccountAll
        }

        let accountNames = accounts
            .filter { selectedAccountsToFilter.contains($0.id) }
            .map(\.name)
            .joined(separator: ", ")

        return LocalizedStringResource(stringLiteral: accountNames)
    }
    
    
    /**
     Returns a localized `NumberFormatter` configured for decimal numbers based on the current locale.
     
     This formatter can be used to format numbers that include a fixed number of fractional digits (like currency).
     
     **Example:**
     ```swift
     let formatter = UtilCurrency.localFormatter
     let formattedNumber = formatter.number(from: "1234.567")
     print(formattedNumber) // Prints "1234.57" or "1234,57" depending on locale
     ```
     
     - Returns: A NumberFormatter configured with locale settings, decimal number style, and rounding mode
     
     - Authors: Fabian Rodriguez
     
     - Date: Sepember 2024
     */
    public static func localFormatter(showCents: Bool) -> NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale.current
        //formatter.maximumIntegerDigits = CurrencyManager.amoutMaxLength
        //formatter.minimumFractionDigits = CurrencyManager.fractionLength
        formatter.minimumFractionDigits = .zero
        formatter.maximumFractionDigits = showCents ? CurrencyManager.fractionLength : .zero
        
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
}
