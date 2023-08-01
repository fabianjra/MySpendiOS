//
//  Colors.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

extension Color {
    
    // MARK: GENERAL
    static let warning = Color("Warning")
    static let shadow = Color("Shadow")
    static let disabledForeground = Color("DisabledForeground")
    static let disabledBackground = Color("DisabledBackground")
    
    // MARK: GRADIANTS
    static let primaryLeading = Color("PrimaryLeading")
    static let primaryTrailing = Color("PrimaryTrailing")
    static let primaryGradiant: Array = [Color.primaryLeading,
                                         Color.primaryTrailing]
    static let secondaryLeading = Color("SecondaryLeading")
    static let secondaryTrailing = Color("SecondaryTrailing")
    static let secondaryGradiant: Array = [Color.secondaryLeading,
                                         Color.secondaryTrailing]
    
    // MARK: BUTTONS
    static let buttonForeground = Color("ButtonForeground")
    static let buttonLinkForeground = Color("ButtonLinkForeground")
    
    //MARK: LIST
    static let listRowForeground = Color("ListRowForeground")
    static let listRowBackground = Color("ListRowBackground")
    
    // MARK: TabView
    static let tabViewIconSelected = Color("TabViewIconSelected")
    static let tabViewIconDeselected = Color("TabViewIconDeselected")
    static let tabViewBackground = Color("TabViewBackground")
    
    // MARK: TEXTFIELDS
    static let textFieldPlaceholder = Color("TextFieldPlaceholder") //AKA: Silver
    static let textFieldForeground = Color("TextFieldForeground")
    static let textfieldBackground = Color("TextFieldBackground")
    static let textFieldIconBackground = Color("TextFieldIconBackground")
    
    // MARK: TEXTS
    static let textPrimaryForeground = Color("TextPrimaryForeground")
    static let textSecondaryForeground = Color("TextSecondaryForeground")
    
    // MARK: VIEWS
    static let divider = Color("Divider")
    static let background = Color("Background")
    static let backgroundTop = Color("BackgroundTop")
    static let backgroundFormLight = Color("BackgroundFormLight")
    static let backgroundFormDark = Color("BackgroundFormDark")
    static let backgroundFormGradiant: Array = [Color.backgroundFormLight,
                                                Color.backgroundFormDark]
}
