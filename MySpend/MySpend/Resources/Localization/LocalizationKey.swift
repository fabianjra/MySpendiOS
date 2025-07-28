//
//  LocalizationKey.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/7/25.
//

import SwiftUICore

protocol Localizable {
    var rawValue: String { get }
}

extension Localizable {
    var key: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
}

struct LocalizationKey {
    
    // MARK: Button
    
    enum Button: String, Localizable {
        case continu = "button.continue"
        case skip = "button.skip"
        case history = "button.history"
        case historySubtitle = "button.history_subtitle"
    }
    
    
    // MARK: - OnBoarding
    
    enum Onboarding: String, Localizable {
        case title = "onboarding.title"
        case enterName = "onboarding.enter_name"
        case enterAccountName = "onboarding.enter_account_name"
    }
    
    // MARK: - Transaction
    
    enum Transaction: String, Localizable {
        case welcome = "transaction.welcome"
    }
    
    
    // MARK: - View
    
    enum View: String, Localizable {
        case empty = "view.empty"
        case emptyAddItem = "view.empty_add_item"
    }
}
