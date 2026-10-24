//
//  CategorySortConfiguration.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/10/26.
//

import Foundation

struct CategorySortConfiguration: Codable, Equatable {
    var sortBy: CategorySortOption = .usage
    var order: SortOrder = .ascending
}

enum CategorySortOption: Codable, CaseIterable {
    case usage
    case title
    case dateCreated

    var localized: LocalizedStringResource {
        switch self {
        case .usage: return .sortByMostOftenUsed
        case .title: return .sortByTitle
        case .dateCreated: return .sortByDateCreated
        }
    }
    
    func orderLocalized(_ order: SortOrder) -> LocalizedStringResource {
        switch self {
            
        case .usage:
            return order == .ascending
            ? .sortOrderMostRecent
            : .sortOrderLeastUsed
            
        case .title: return order.localized
            
        case .dateCreated:
            return order == .ascending
            ? .sortOrderMostRecent
            : .sortOrderLeastUsed
        
        }
    }
}
