//
//  TransactionSortConfiguration.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 29/10/26.
//

import Foundation

struct TransactionSortConfiguration: Codable, Equatable {
    var sortBy: TransactionSortOption = .dateTransaction
    var order: SortOrder = .ascending
}

enum TransactionSortOption: Codable, CaseIterable {
    case dateTransaction
    case amount
    case title

    var localized: LocalizedStringResource {
        switch self {
        case .dateTransaction: return .sortByDateTransaction
        case .amount: return .sortByAmount
        case .title: return .sortByTitle
        }
    }
    
    func orderLocalized(_ order: SortOrder) -> LocalizedStringResource {
        switch self {
            
        case .dateTransaction:
            return order == .ascending
            ? .sortOrderMostRecent
            : .sortOrderLeastUsed
            
        case .amount:
            return order == .ascending
            ? .sortOrderHighest
            : .sortOrderLowest
            
        case .title: return order.localized
        }
    }
}
