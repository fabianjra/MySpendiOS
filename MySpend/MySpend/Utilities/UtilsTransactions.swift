//
//  UtilsTransactions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

struct UtilsTransactions {
    
    /**
     Filtra las transacciones por intervalos de tiempo seleccionados y las ordena en forma descendente en base a la fecha de la transaccion
     */
    static func filteredTransactions(_ selectedDate: Date,
                                     transactions: [TransactionModel],
                                     for interval: DateTimeInterval,
                                     sortTransactions: SortTransactions? = nil) -> [TransactionModel] {
        
        var sortedTransactions = transactions
        
        if let sortTransactions = sortTransactions {
            switch sortTransactions {
            case .byDateNewest:
                sortedTransactions.sort(by: { $0.dateTransaction > $1.dateTransaction })
            
            case .byDateOldest:
                sortedTransactions.sort(by: { $0.dateTransaction < $1.dateTransaction })
                
            case .byAmountHigher:
                sortedTransactions.sort(by: { $0.amount > $1.amount })
                
            case .byAmountLower:
                sortedTransactions.sort(by: { $0.amount < $1.amount })
                
            case .byCategoryNameAz:
                sortedTransactions.sort(by: { $0.category.name < $1.category.name })
                
            case .byCategoryNameZa:
                sortedTransactions.sort(by: { $0.category.name > $1.category.name })
            }
        }
        
        let calendar = Calendar.current
        
        switch interval {
            
        case .day:
            return sortedTransactions.filter {
                calendar.isDate($0.dateTransaction, inSameDayAs: selectedDate)
            }
            
        case .week:
            if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) {
                let endOfSunday = calendar.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
                
                return sortedTransactions.filter {
                    $0.dateTransaction >= weekInterval.start && $0.dateTransaction <= endOfSunday
                }
            }
            return []
            
        case .month:
            return sortedTransactions.filter {
                calendar.isDate($0.dateTransaction, equalTo: selectedDate, toGranularity: .month)
            }
            
        case .year:
            return sortedTransactions.filter {
                calendar.isDate($0.dateTransaction, equalTo: selectedDate, toGranularity: .year)
            }
        }
    }
}
