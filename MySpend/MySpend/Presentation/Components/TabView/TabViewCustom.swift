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
            //Add padding when is iPhone SE screen.
            //.padding(.bottom, Utils.getEdgeInsets().bottom == .zero ? 10 : .zero)
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
            Color.white
                .frame(height: Frames.tabViewHeight)
                .cornerRadius(.infinity)
                .shadow(color: .shadow.opacity(Colors.opacityHalf),
                        radius: Radius.shadow,
                        x: .zero, y: .zero)
                .padding(.horizontal)
                .padding(.bottom)
            
            
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
                                .font(.custom(FontFamily.regular.rawValue,
                                                  size: FontSizes.small))
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
