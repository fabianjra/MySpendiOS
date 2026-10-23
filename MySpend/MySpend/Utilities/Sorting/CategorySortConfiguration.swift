//
//  CategorySortConfiguration.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/10/26.
//

import Foundation

struct CategorySortConfiguration: Codable, Equatable {
    var sortBy: CategorySortOption = .title
    var order: SortOrder = .ascending
}

enum CategorySortOption: Codable, CaseIterable {
    case dateCreated
    case title

    var localized: LocalizedStringResource {
        switch self {
        case .dateCreated: return .sortByDateCreated
        case .title: return .sortByTitle
        }
    }
}
