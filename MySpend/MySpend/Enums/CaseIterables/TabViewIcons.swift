//
//  TabViewIcons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

enum TabViewIcons: String, CaseIterable, Identifiable, LocalizableProtocol {
    public var id: Self { self }
    
    case transaction
    case settings
    
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
    
    var table: String { LocalizableTable.enums }
    
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
