//
//  LocalizationKey.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/7/25.
//

import SwiftUICore

struct LocalizationKey {
    
    // MARK: - OnBoarding
    
    enum Onboarding: String {
        case welcome = "onboarding.welcome"
        case start = "onboarding.start"
        
        var key: LocalizedStringKey {
            LocalizedStringKey(self.rawValue)
        }
    }
    
    // MARK: - View
    
    enum View: String {
        case empty = "view.empty"
        case emptyAddItem = "view.empty_add_item"
        
        var key: LocalizedStringKey {
            LocalizedStringKey(self.rawValue)
        }
    }
}
