//
//  TotalBalanceViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

class TotalBalanceViewModel: ObservableObject {
    
    @Published var totalIncomeFormatted: String =  Decimal.zero.convertAmountDecimalToString.addCurrencySymbol
    @Published var totalExpensesFormatted: String = Decimal.zero.convertAmountDecimalToString.addCurrencySymbol
    @Published var totalBalanceFormatted: String = Decimal.zero.convertAmountDecimalToString.addCurrencySymbol
    
    /**
     Esta función filtra las transacciones por transactionType, sumando los ingresos (income) y los gastos (expense).
     Luego, calcula el balance final restando los gastos a los ingresos y formatea el balance.
     */
    func calculateTotalBalance(_ transactions: [TransactionModelFB]) {
        
        let totalIncome = transactions
            .filter { $0.transactionType == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }

        let totalExpenses = transactions
            .filter { $0.transactionType == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }

        let totalBalance = totalIncome - totalExpenses

        totalIncomeFormatted = totalIncome.convertAmountDecimalToString.addCurrencySymbol
        totalExpensesFormatted = totalExpenses.convertAmountDecimalToString.addCurrencySymbol
        totalBalanceFormatted = totalBalance.convertAmountDecimalToString.addCurrencySymbol
    }
}
