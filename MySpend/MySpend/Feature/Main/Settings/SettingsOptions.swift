//
//  SettingsOptions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

// MARK: - ACCOUNT

/**
 SwiftUI is data-driven reactive framework and Swift is strict typed language,
 so instead of trying to put different View types (due to generics) into one array (requires same type),
 we can make data responsible for providing corresponding view (that now with help of ViewBuilder is very easy).
 
 Reference: https://github.com/Asperi-Demo/4SwiftUI/blob/master/PlayOn_iOS/PlayOn_iOS/Findings/TestDataDrivenScreenContruction.swift
 
 **Example:**
 ```swift
 List(SettingsOptions.allCases) { option in
         NavigationLink(option.rawValue, destination: option.view)
 }
 ```
 
 - Authors: Fabian Rodriguez
 
 - Version: 1.0
 
 - Date: Jul 2023
 */
enum ProfileOptions: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case personalInformation
    case validateAccount
    
    var title: LocalizedStringResource {
        switch self {
        case .personalInformation: return .settingsProfileOptionPersonalInformation
        case .validateAccount: return .settingsProfileOptionValidateAccount
        }
    }
    
    var icon: String {
        switch self {
        case .personalInformation: return "👤"
        case .validateAccount: return "✅"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .personalInformation: PersonalInformationView()
        case .validateAccount: ValidateAccountView()
        }
    }
}


// MARK: - GENERAL

enum ContentOptions: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case accounts
    case categories
    case currencySymbol
    case dateTimeInterval
    
    var title: LocalizedStringResource {
        switch self {
        case .accounts: return .settingsGeneralOptionAccounts
        case .categories: return .settingsGeneralOptionCategories
        case .currencySymbol: return .settingsGeneralOptionCurrencySymbol
        case .dateTimeInterval: return .settingsGeneralOptionDateTimeInterval
        }
    }
    
    var icon: String {
        switch self {
        case .accounts: return "🏦"
        case .categories: return "📋"
        case .currencySymbol: return "💰"
        case .dateTimeInterval: return "📅"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .accounts: AccountView()
        case .categories: CategoryView()
        case .currencySymbol: CurrencyListView()
        case .dateTimeInterval: DateTimeIntervalListView()
        }
    }
}

