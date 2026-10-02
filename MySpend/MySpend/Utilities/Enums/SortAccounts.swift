//
//  SortAccounts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

enum SortAccounts: String, Codable {
    case byNameAz = "Name A-Z"
    case byNameZa = "Name Z-A"
    
    case byCreationNewest = "Creation newest"
    case byCreationOldest = "Creation oldest"

    var toggle: SortAccounts {
        switch self {
        case .byNameAz: return .byNameZa
        case .byNameZa: return .byNameAz
            
        case .byCreationNewest: return .byCreationOldest
        case .byCreationOldest: return .byCreationNewest
        }
    }
    
    func label(inverted: Bool = true) -> some View {
        switch self {
        case .byNameAz: return inverted ? Label.nameZa : Label.nameAz
        case .byNameZa: return inverted ? Label.nameAz : Label.nameZa
            
        case .byCreationNewest: return inverted ? Label.creationOldestFirst : Label.creationNewestFirst
        case .byCreationOldest: return inverted ? Label.creationNewestFirst : Label.creationOldestFirst
        }
    }
}
