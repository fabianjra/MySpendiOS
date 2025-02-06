//
//  SettingsOptions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

// MARK: ACCOUNT

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
    case changePassword = "Change my password"
    case validateAccount = "Validate account"
    
    var icon: Image {
        switch self {
        case .changeName: return Image.personFill
        case .changePassword: return Image.lockFill
        case .validateAccount: return Image.checkmark
        }
    }
    
    var showOption: Bool {
        switch self {
        case .changeName: return ConstantValidations.showChangeName
        case .changePassword: return ConstantValidations.showChangePassword
        case .validateAccount: return ConstantValidations.showValidateAccount
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        //"for: .navigationBar" is disabling the navigator to navigate the next View.
        case .changeName: ChangeNameView().toolbar(.hidden, for: .navigationBar)
        case .changePassword:ChangePasswordView().toolbar(.hidden, for: .navigationBar)
        case .validateAccount: ValidateAccountView().toolbar(.hidden, for: .navigationBar)
        }
    }
}

//*********************************************************
// MARK: CONTENT

enum ContentOptions: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case categories = "Categories"
    case currencySymbol = "Currency symbol"
    case dateTimeInterval = "Time interval"
    
    var icon: Image {
        switch self {
        case .categories: return Image.listBulletClipboardFill
        case .currencySymbol: return Image.dollar
        case .dateTimeInterval: return Image.calendar
        }
    }
    
    var showOption: Bool {
        switch self {
        case .categories: return ConstantValidations.showCategories
        case .currencySymbol: return ConstantValidations.showCurrencySymbol
        case .dateTimeInterval: return ConstantValidations.showDateTimeInterval
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        //"for: .navigationBar" is disabling the navigator to navigate the next View.
        case .categories: CategoryView().toolbar(.hidden, for: .navigationBar)
        case .currencySymbol: CurrencyListView().toolbar(.hidden, for: .navigationBar)
        case .dateTimeInterval: DateTimeIntervalListView().toolbar(.hidden, for: .navigationBar)
        }
    }
}

