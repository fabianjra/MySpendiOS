//
//  Fonts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct Fonts {
    
    static let body = Font.custom(MontserratFamily.regular.rawValue, size: 14)
}

enum MontserratFamily: String {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case semibold = "Montserrat-SemiBold"
    case thin = "Montserrat-Thin"
}
