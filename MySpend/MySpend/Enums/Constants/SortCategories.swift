//
//  SortCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/12/24.
//

import SwiftUI

enum SortCategories: String, Codable {
    case byCreationNewest = "Creation newest"
    case byCreationOldest = "Creation oldest"
    
    case byNameAz = "Name A-Z"
    case byNameZa = "Name Z-A"
    
    case byMostOftenUsed = "Most often used"
    
    var toggle: SortCategories {
        switch self {
        case .byCreationNewest: return .byCreationOldest
        case .byCreationOldest: return .byCreationNewest
            
        case .byNameAz: return .byNameZa
        case .byNameZa: return .byNameAz
            
        case .byMostOftenUsed: return self
        }
    }
    
    func label(inverted: Bool = true) -> some View {
        switch self {
        case .byCreationNewest: return inverted ? Label.creationOldestFirst : Label.creationNewestFirst
        case .byCreationOldest: return inverted ? Label.creationNewestFirst : Label.creationOldestFirst
            
        case .byNameAz: return inverted ? Label.nameZa : Label.nameAz
        case .byNameZa: return inverted ? Label.nameAz : Label.nameZa
            
        case .byMostOftenUsed: return Label.mostOftenUsed
        }
    }
}
