//
//  SortOrder.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/10/26.
//

import Foundation

enum SortOrder: String, Codable, CaseIterable {
    case ascending
    case descending

    var localized: LocalizedStringResource {
        switch self {
        case .ascending: return .sortAscending
        case .descending: return .sortDescending
        }
    }
}
