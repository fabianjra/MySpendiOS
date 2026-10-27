//
//  TotalBalanceViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

@Observable
final class TotalBalanceViewModel {
    
    var totalIncomesFormatted = ""
    var totalExpensesFormatted = ""
    
    /**
     Esta función filtra las transacciones por CategoryType, sumando los ingresos (income) y los gastos (expense).
     Luego, calcula el balance final restando los gastos a los ingresos y formatea el balance.
     */
    func calculateTotalBalance(_ transactions: [TransactionModel]) {
        
        let totalIncome = transactions
            .filter { $0.category.type == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }

        let totalExpenses = transactions
            .filter { $0.category.type  == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }

        totalIncomesFormatted = totalIncome.convertAmountDecimalToString.addCurrencySymbol
        totalExpensesFormatted = totalExpenses.convertAmountDecimalToString.addCurrencySymbol
    }
}
