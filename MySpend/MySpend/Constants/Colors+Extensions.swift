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
    static let primaryButtonText = Color("PrimaryButtonText")
    static let primaryButtonLight = Color("PrimaryButtonLeading")
    static let primaryButtonMedium = Color("PrimaryButtonTrailing")
    static let primaryButtonGradiant: Array = [Color.primaryButtonLight,
                                               Color.primaryButtonMedium]
    
    // MARK: Textfields
    static let textFieldPlaceholder = Color("TextFieldPlaceholder") //AKA: Silver
    static let textFieldForeground = Color("TextFieldForeground")
    static let textfieldBackground = Color("TextFieldBackground")
    static let textFieldIconBackground = Color("TextFieldIconBackground")
    
    // MARK: Background
    static let background = Color("Background")
    static let backgroundLight = Color("BackgroundFormLeading")
    static let backgroundMedium = Color("BackgroundFormTrailing")
    static let backgroundGradiant: Array = [Color.backgroundLight,
                                             Color.backgroundMedium]
}
