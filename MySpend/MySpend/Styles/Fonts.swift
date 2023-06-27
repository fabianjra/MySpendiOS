//
//  Fonts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

/*
 .extraLargeTitle
 iOS 17         36.0    SFUI-Bold
 
 .extraLargeTitle2
 iOS 17         28.0    SFUI-Bold
 
 .largeTitle    34.0    SFUI-Regular
 .title1        28.0    SFUI-Regular
 .title2        22.0    SFUI-Regular
 .title3        20.0    SFUI-Regular
 .headline      17.0    SFUI-Semibold
 .subheadline   15.0    SFUI-Regular
 .body          17.0    SFUI-Regular
 .callout       16.0    SFUI-Regular
 .footnote      13.0    SFUI-Regular
 .caption1      12.0    SFUI-Regular
 .caption2      11.0    SFUI-Regular
 */

public enum MontserratFamily: String {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case semibold = "Montserrat-SemiBold"
    case thin = "Montserrat-Thin"
}

public enum FontSizes {
    case small
    case body
    case big
    
    var size: CGFloat {
        switch self {
        case .small: return UIFont.preferredFont(forTextStyle: .caption1).pointSize //12
        case .body: return UIFont.preferredFont(forTextStyle: .body).pointSize //17
        case .big: return UIFont.preferredFont(forTextStyle: .title3).pointSize //20
        }
    }
}
