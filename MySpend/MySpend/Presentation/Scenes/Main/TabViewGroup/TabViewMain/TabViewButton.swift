//
//  TabViewButton.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct TabViewButton: View {
    
    @Binding var selectedTab: TabViewIcons
    let item: TabViewIcons
    
    var body: some View {
        Button {
            selectedTab = item
        } label: {
            VStack{
                Image.imageSelected(selectedTab == item,
                                    imageSelected: item.iconSelected,
                                    imageDeselected: item.iconDeselected)
                
                .frame(width: FrameSize.width.tabViewIcon,
                       height: FrameSize.height.tabViewIcon)
                
                .tint(selectedTab == item ?
                      Color.tabViewIconSelected
                      : Color.tabViewIconDeselected)
                
                
                Text(item.rawValue)
                    .font(.montserrat(size: .small))
                    .tint(selectedTab == item ?
                          Color.tabViewIconSelected
                          : Color.tabViewIconDeselected)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: TabViewIcons = .transaction
    ZStack {
        Color.backgroundBottom
        
        HStack {
            TabViewButton(selectedTab: $selectedTab, item: .transaction)
        }
        .background(Color.textPrimaryForeground)
    }
}
