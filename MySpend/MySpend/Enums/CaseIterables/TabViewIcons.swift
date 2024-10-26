//
//  TabViewIcons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

enum TabViewIcons: String, CaseIterable, Identifiable {
    public var id: Self { self }
    
    case transaction = "Transactions"
    case settings = "Settings"
    
    var iconSelected: Image {
        switch self {
        case .transaction: return Image.tabResumeFill
        case .settings: return Image.tabSettingsFill
        }
    }
    
    var iconDeselected: Image {
        switch self {
        case .transaction: return Image.tabResume
        case .settings: return Image.tabSettings
        }
    }
    
//    @ViewBuilder
//    var view: some View {
//        switch self {
//        case .resume:
//            ResumeView()
//        case .settings:
//            SettingsView()
//        }
//    }
}
