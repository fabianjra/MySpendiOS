//
//  Fonts+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

extension Font {
    
    /*
     .extraLargeTitle
     iOS 17         36.0    SFUI-Bold
     
     .extraLargeTitle2
     iOS 17         28.0    SFUI-Bold
     
     .largeTitle    34.0    SFUI-Regular
     .title         28.0    SFUI-Regular
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
    
    /// Returns the native SwiftUI `.caption` font style.
    static let smallest: Font = .caption

    /// Returns the native SwiftUI `.footnote` font style.
    static let small: Font = .footnote

    /// Returns the native SwiftUI `.callout` font style.
    static let medium: Font = .callout
}
