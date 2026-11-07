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
