//
//  Colors.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

extension Color {
    
    // MARK: GENERAL GRADIENTS
    static let primaryGradiant: Array = [Color.accentColor,
                                         Color.accentColor]
    static let backgroundGradient = RadialGradient(colors: [.backgroundTop, .backgroundBottom],
                                                          center: .top,
                                                          startRadius: .zero,
                                                          endRadius: ConstantColors.endRadiusBackground)
    
    // MARK: VIEWS
    static let backgroundFormGradiant: Array = [Color.backgroundFormLight,
                                                Color.backgroundFormDark]
}
