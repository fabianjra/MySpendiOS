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
                
                .frame(width: ConstantFrames.tabViewIcon,
                       height: ConstantFrames.tabViewIcon)
                
                .tint(selectedTab == item ?
                      Color.tabViewIconSelected
                      : Color.tabViewIconDeselected)
                
                
                Text(item.rawValue.capitalized)
                    .font(.montserrat(size: .small))
                    .tint(selectedTab == item ?
                          Color.tabViewIconSelected
                          : Color.tabViewIconDeselected)
            }
        }
    }
}

struct TabViewButton_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var selectedTab: TabViewIcons = .resume
        
        ZStack {
            Color.background
            
            HStack {
                TabViewButton(selectedTab: $selectedTab, item: .resume)
            }
            .background(Color.textPrimaryForeground)
        }
    }
}
