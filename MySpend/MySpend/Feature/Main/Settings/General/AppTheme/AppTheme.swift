//
//  AppTheme.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/9/26.
//

import Foundation
import SwiftUI

enum AppTheme: Identifiable, CaseIterable, Codable {
    public var id: Self { self }
    
    case system
    case light
    case dark
    
    var colorScheme: ColorScheme? {
        switch self {
            
        case .system: return .none
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var localizedName: LocalizedStringResource {
        switch self {
            
        case .system: return .appThemeSystem
        case .light: return .appThemeLight
        case .dark: return .appThemeDark
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "🌓"
        case .light: return "🌝"
        case .dark: return "🌚"
        }
    }
}
