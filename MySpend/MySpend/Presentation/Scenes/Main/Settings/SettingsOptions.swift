//
//  SettingsOptions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

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

enum SettingsOptions: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case categories = "Categories"
    case changeName = "Change my name"
    case changePassword = "Change my password"
    case validateAccount = "Validate account"
    
    @ViewBuilder
    var view: some View {
        switch self {
        //"for: .navigationBar" is disabling the navigator to navigate the next View.
        case .categories: Color.red
        case .changeName: RegisterView().toolbar(.hidden)
        case .changePassword: Color.green.toolbar(.hidden)
        case .validateAccount: Color.yellow.toolbar(.hidden)
        }
    }
}
