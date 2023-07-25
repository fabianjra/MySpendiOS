//
//  TabViewButtons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/7/23.
//

import SwiftUI

struct TabViewButtons: View {
    
    @State var selectedTab: TabViewIcons
    let item: TabViewIcons
    
    var body: some View {
        Button {
            selectedTab = item
        } label: {
            VStack{
                Image.imageSelected(selectedTab == item,
                                    imageSelected: item.image,
                                    imageDeselected: item.imageDeselected)
                
                .frame(width: Frames.tabViewIcon,
                       height: Frames.tabViewIcon)
                
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

struct TabViewButtons_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            Color.background
            
            HStack {
                TabViewButtons(selectedTab: .resume, item: .resume)
            }
            .background(Color.textPrimaryForeground)
        }
    }
}
