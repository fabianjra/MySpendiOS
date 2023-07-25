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
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                
                selectedTab.view
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
        TabViewContainer {
            //TODO: Add new transaction function.
        } content: {
            ForEach(TabViewIcons.allCases, id: \.id) { item in
                
                TabViewButton(selectedTab: $selectedTab, item: item)
                    .padding(.horizontal, Views.paddingTabViewHorizontal)
                    .padding(.bottom)

                if item == TabViewIcons.allCases.first {
                    Spacer()
                }
            }
        }
    }
}

struct TabViewCustom_Previews: PreviewProvider {
    static var previews: some View {
        TabViewCustom(selectedTab: .resume)
    }
}
