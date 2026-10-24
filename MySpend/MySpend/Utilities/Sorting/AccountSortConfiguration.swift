//
//  AccountSortConfiguration.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

struct AccountSortConfiguration: Codable, Equatable {
    var sortBy: AccountSortOption = .dateCreated
    var order: SortOrder = .ascending
}

enum AccountSortOption: Codable, CaseIterable {
    case dateCreated
    case title
    
    var localized: LocalizedStringResource {
        switch self {
        case .dateCreated: return .sortByDateCreated
        case .title: return .sortByTitle
        }
    }
    
    func orderLocalized(_ order: SortOrder) -> LocalizedStringResource {
        switch self {
        case .dateCreated:
            return order == .ascending
            ? .sortOrderMostRecent
            : .sortOrderLeastUsed
            
        case .title: return order.localized
        }
    }
}
