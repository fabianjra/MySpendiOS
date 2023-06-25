//
//  Fonts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct Fonts {
    
    static let light = Font.custom(MontserratFamily.light.rawValue, size: 16)
    static let regular = Font.custom(MontserratFamily.regular.rawValue, size: 16)
    static let semibold = Font.custom(MontserratFamily.semibold.rawValue, size: 16)
    static let thin = Font.custom(MontserratFamily.thin.rawValue, size: 16)
}

enum MontserratFamily: String {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case semibold = "Montserrat-SemiBold"
    case thin = "Montserrat-Thin"
}
