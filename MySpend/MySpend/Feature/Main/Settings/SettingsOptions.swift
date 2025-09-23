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
enum AccountOptions: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case changeName = "Change my name"
    case validateAccount = "Validate account"
    
    var icon: Image {
        switch self {
        case .changeName: return Image.personFill
        case .validateAccount: return Image.checkmark
        }
    }
    
    var showOption: Bool {
        switch self {
        case .changeName: return ConstantValidations.showChangeName
        case .validateAccount: return ConstantValidations.showValidateAccount
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .changeName: ChangeNameView()
        case .validateAccount: ValidateAccountView()
        }
    }
}


// MARK: - CONTENT

enum ContentOptions: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case accounts = "Accounts"
    case categories = "Categories"
    case currencySymbol = "Currency symbol"
    case dateTimeInterval = "Time interval"
    
    var icon: Image {
        switch self {
        case .accounts: return Image.walletFill
        case .categories: return Image.listBulletClipboardFill
        case .currencySymbol: return Image.dollar
        case .dateTimeInterval: return Image.calendar
        }
    }
    
    var showOption: Bool {
        switch self {
        case .accounts: return ConstantValidations.showAccounts
        case .categories: return ConstantValidations.showCategories
        case .currencySymbol: return ConstantValidations.showCurrencySymbol
        case .dateTimeInterval: return ConstantValidations.showDateTimeInterval
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

