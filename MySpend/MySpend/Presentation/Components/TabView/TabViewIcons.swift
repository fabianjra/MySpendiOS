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
    
    var image: Image {
        switch self {
        case .resume: return Image.dolarSquareFill
        case .settings: return Image.sliderHorizontal
        }
    }
    
    var imageDeselected: Image {
        switch self {
        case .resume: return Image.dolarSquare
        case .settings: return Image.sliderHorizontal
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .resume: Color.blue
        case .settings: Color.red
        }
    }
}
