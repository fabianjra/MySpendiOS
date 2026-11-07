//
//  TransactionTotals.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/11/26.
//

import Foundation

struct TransactionTotals {
    var incomes: Decimal = .zero
    var expenses: Decimal = .zero

    var balance: Decimal {
        incomes - expenses
    }
}

extension Array where Element == TransactionModel {
    
    func calculateTotals() -> TransactionTotals {
        reduce(into: TransactionTotals()) { totals, transaction in
            
            switch transaction.category.type {
                
            case .income:
                totals.incomes += transaction.amount
                
            case .expense:
                totals.expenses += transaction.amount
            }
        }
    }
}
