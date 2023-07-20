//
//  TabViewCustom.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/23.
//

import SwiftUI

struct TabViewCustom: View {
    
    @State private var selectedTab: TabViewIcons
    
    init(selectedTab: TabViewIcons) {
        self.selectedTab = selectedTab
        //UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                
                selectedTab.view
                    .edgesIgnoringSafeArea(.bottom)
                    //.tag(selectedTab)
            }
            
            tabView
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            //Disable Swipe to go back.
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
    }
    
    var tabView: some View {
        ZStack{
            
            //MARK: BACKGROUND
            TabViewShape()
            
            
            //MARK: ITEMS
            HStack {
                ForEach(TabViewIcons.allCases, id: \.id) { item in
                    
                    Button {
                        selectedTab = item
                    } label: {
                        VStack{

                            item.imageIcon
                                .resizable()
                                .frame(width: Frames.tabViewIcon, height: Frames.tabViewIcon)
                                .accentColor(selectedTab == item ?
                                             Color.tabViewIconSelected
                                             : Color.tabViewIconDeselected)
                            
                            Text(item.rawValue.capitalized)
                                .font(.montserrat(size: .small))
                                .accentColor(selectedTab == item ?
                                             Color.tabViewIconSelected
                                             : Color.tabViewIconDeselected)
                        }
                    }
                    .padding(.horizontal, Views.paddingTabViewHorizontal)
                }
            }
            .padding(.bottom)
        }
    }
}

struct TabViewCustom_Previews: PreviewProvider {
    static var previews: some View {
        TabViewCustom(selectedTab: .resume)
    }
}
