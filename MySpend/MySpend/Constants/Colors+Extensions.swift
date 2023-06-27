//
//  Colors.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import Foundation
import SwiftUI

extension Color {
    
    // MARK: Buttons
    static let buttonForeground = Color("ButtonForeground")
    
    // MARK: General
    static let primaryLight = Color("PrimaryLight")
    static let primaryDark = Color("PrimaryDark")
    static let primaryGradiant: Array = [Color.primaryLight,
                                         Color.primaryDark]
    
    // MARK: Textfields
    static let textFieldPlaceholder = Color("TextFieldPlaceholder") //AKA: Silver
    static let textFieldForeground = Color("TextFieldForeground")
    static let textfieldBackground = Color("TextFieldBackground")
    static let textFieldIconBackground = Color("TextFieldIconBackground")
    
    // MARK: Texts
    static let textPrimaryForeground = Color("TextPrimaryForeground")
    
    // MARK: Views
    static let background = Color("Background")
    static let backgroundFormLight = Color("BackgroundFormLight")
    static let backgroundFormDark = Color("BackgroundFormDark")
    static let backgroundFormGradiant: Array = [Color.backgroundFormLight,
                                                Color.backgroundFormDark]
}
