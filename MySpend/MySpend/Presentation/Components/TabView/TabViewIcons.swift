//
//  TabViewIcons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

enum TabViewIcons: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case resume //History will be inside of this view.
    case settings //Categories will be inside of this view.
    
    var iconSelected: Image {
        switch self {
        case .resume: return Image.tabResumeFill
        case .settings: return Image.tabSettingsFill
        }
    }
    
    var iconDeselected: Image {
        switch self {
        case .resume: return Image.tabResume
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
