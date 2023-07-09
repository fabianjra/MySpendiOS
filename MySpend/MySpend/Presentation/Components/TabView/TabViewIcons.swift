//
//  TabViewIcons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

enum TabViewIcons: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case resume
    case history
    case category
    case settings
    
    var imageIcon: Image {
        switch self {
        case .resume: return Image.dolarSquareFill
        case .history: return Image.stackFill
        case .category: return Image.listBulletClipboardFill
        case .settings: return Image.sliderHorizontal
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .resume: Color.blue
        case .history: Color.green
        case .category: Color.yellow
        case .settings: Color.red
        }
    }
}
