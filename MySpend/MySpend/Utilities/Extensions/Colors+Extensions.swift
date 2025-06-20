//
//  Colors.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

extension Color {
    
    // MARK: GENERAL GRADIENTS
    static let primaryGradiant: Array = [Color.primaryLeading,
                                         Color.primaryTrailing]
    static let secondaryGradiant: Array = [Color.secondaryLeading,
                                         Color.secondaryTrailing]
    static let backgroundContentGradient = RadialGradient(colors: [Color.backgroundTop,
                                                                   Color.backgroundBottom],
                                                          center: .top,
                                                          startRadius: .zero,
                                                          endRadius: ConstantColors.endRadiusBackground)
    
    // MARK: VIEWS
    static let backgroundFormGradiant: Array = [Color.backgroundFormLight,
                                                Color.backgroundFormDark]
}
