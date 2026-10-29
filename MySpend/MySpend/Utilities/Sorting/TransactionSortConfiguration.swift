//
//  TransactionSortConfiguration.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 29/10/26.
//

import Foundation

struct TransactionSortConfiguration: Codable, Equatable {
    var sortBy: TransactionSortOption = .dateCreated
    var order: SortOrder = .ascending
}

enum TransactionSortOption: Codable, CaseIterable {
    case dateCreated
    case amount
    case title

    var localized: LocalizedStringResource {
        switch self {
        case .dateCreated: return .sortByDateCreated
        case .amount: return .sortByAmount
        case .title: return .sortByTitle
        }
    }
    
    func orderLocalized(_ order: SortOrder) -> LocalizedStringResource {
        switch self {
            
        case .dateCreated:
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
