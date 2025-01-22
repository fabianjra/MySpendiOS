//
//  SortCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/12/24.
//

import SwiftUI

enum SortCategories: Codable {
    case byCreationNewest
    case byCreationOldest
    
    case byNameAz
    case byNameZa
    
    var toggle: SortCategories {
        switch self {
        case .byCreationNewest: return .byCreationOldest
        case .byCreationOldest: return .byCreationNewest
            
        case .byNameAz: return .byNameZa
        case .byNameZa: return .byNameAz
        }
    }
    
    func label(inverted: Bool = true) -> some View {
        switch self {
        case .byCreationNewest: return inverted ? Label.creationOldestFirst : Label.creationNewestFirst
        case .byCreationOldest: return inverted ? Label.creationNewestFirst : Label.creationOldestFirst
            
        case .byNameAz: return inverted ? Label.nameZa : Label.nameAz
        case .byNameZa: return inverted ? Label.nameAz : Label.nameZa
        }
    }
}


// MARK: USER DEFAULTS MANAGER

extension SortCategories {
    
    /**
     Gets value stored in `UserDefaults`.
     If there is not data stored, will get a default value
     */
    static var userDefaultsValue: SortCategories {
        get {
            return UserDefaultsManager<SortCategories>(for: .sortCategories).value ?? .byNameAz
        }
        
        set {
            var manager = UserDefaultsManager<SortCategories>(for: .sortCategories)
            manager.value = newValue
        }
    }
    
    static var removeUserDefaultsValue: Void {
        UserDefaultsManager<SortCategories>(for: .sortCategories).removeValue
    }
}
