//
//  ThemeManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/26.
//

import SwiftUI

@Observable
final class ThemeManager {
    static let shared = ThemeManager()
    
    var theme: AppTheme = UserDefaultsManager.appTheme {
        didSet {
            UserDefaultsManager.appTheme = theme
        }
    }
    
    private init() {}
}
