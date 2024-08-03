//
//  MainView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: TabViewIcons
    
    @State private var showNewItemModal = false
    
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
        
        .sheet(isPresented: $showNewItemModal) {
            NewTransactionView()
                .presentationDetents([.large])
        }
    }
    
    var tabView: some View {
        TabViewContainer {
            
            showNewItemModal = true
            
        } content: {
            ForEach(TabViewIcons.allCases, id: \.id) { item in
                
                TabViewButton(selectedTab: $selectedTab, item: item)
                    .padding(.horizontal, ConstantViews.paddingTabViewHorizontal)
                    .padding(.bottom)

                if item == TabViewIcons.allCases.first {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView(selectedTab: .resume)
}
