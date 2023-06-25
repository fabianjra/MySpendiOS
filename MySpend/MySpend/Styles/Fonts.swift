//
//  Fonts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct Fonts {
    static let light = Font.custom(MontserratFamily.light.rawValue, size: 17)
    static let regular = Font.custom(MontserratFamily.regular.rawValue, size: 17)
    static let semibold = Font.custom(MontserratFamily.semibold.rawValue, size: 17)
    static let thin = Font.custom(MontserratFamily.thin.rawValue, size: 17)
    
    static let primaryButton = Font.custom(MontserratFamily.regular.rawValue,
                                           size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    
    static let primaryTextfield = Font.custom(MontserratFamily.regular.rawValue,
                                           size: UIFont.preferredFont(forTextStyle: .body).pointSize)
}

private enum MontserratFamily: String {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case semibold = "Montserrat-SemiBold"
    case thin = "Montserrat-Thin"
}


private enum Sizes: CGFloat {
    case primaryButton = 20.0
}
