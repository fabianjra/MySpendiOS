//
//  Colors.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

extension Color {
    
    // MARK: Buttons
    static let buttonForeground = Color("ButtonForeground")
    static let buttonForegroundDisabled = Color("ButtonForegroundDisabled")
    static let buttonBackgroundDisabled = Color("ButtonBackgroundDisabled")
    static let buttonLinkForeground = Color("ButtonLinkForeground")
    
    // MARK: General
    static let shadow = Color("Shadow")
    static let primaryLeading = Color("PrimaryLeading")
    static let primaryTrailing = Color("PrimaryTrailing")
    static let primaryGradiant: Array = [Color.primaryLeading,
                                         Color.primaryTrailing]
    static let secondaryLeading = Color("SecondaryLeading")
    static let secondaryTrailing = Color("SecondaryTrailing")
    static let secondaryGradiant: Array = [Color.secondaryLeading,
                                         Color.secondaryTrailing]
    
    // MARK: TabView
    static let tabViewIconSelected = Color("TabViewIconSelected")
    static let tabViewIconDeselected = Color("TabViewIconDeselected")
    
    // MARK: Textfields
    static let textFieldPlaceholder = Color("TextFieldPlaceholder") //AKA: Silver
    static let textFieldForeground = Color("TextFieldForeground")
    static let textfieldBackground = Color("TextFieldBackground")
    static let textFieldIconBackground = Color("TextFieldIconBackground")
    
    // MARK: Texts
    static let textPrimaryForeground = Color("TextPrimaryForeground")
    static let textSecondaryForeground = Color("TextSecondaryForeground")
    static let textErrorForeground = Color("TextErrorForeground")
    
    // MARK: Views
    static let divider = Color("Divider")
    static let background = Color("Background")
    static let backgroundFormLight = Color("BackgroundFormLight")
    static let backgroundFormDark = Color("BackgroundFormDark")
    static let backgroundFormGradiant: Array = [Color.backgroundFormLight,
                                                Color.backgroundFormDark]
}
