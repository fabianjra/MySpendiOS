//
//  TabViewMain.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct TabViewMain: View {
    
    @State private var showNewTransactionModal = false
    //@State private var selectedTab: TabViewIcons = .transaction
    @State private var navigateToHistory: Bool = false
    @State private var selectedDate: Date = .now
    
    @SceneStorage("selectedTab") private var selectedTabIndex = 0
    @State private var searchText: String = ""
    
//    init() {
//        UITabBar.appearance().isHidden = true
//    }
    
    var body: some View {
        //ZStack(alignment: .bottom) {
        VStack {
            
            /*
             Los tabView siempre estan cargadas en memoria, su totalidad de vistas,
             en este caso las 2 vistas estan cargadas en memoria.
             Por eso, se se hace scroll en la vista principal, se cambia de vista y luego vuelve,
             la vista permanece como quedó.
             
            TabView(selection: $selectedTab) {
                
                /// Los tags permiten que las vistas cambien entre una seleccion u otra en el TabView.
                TransactionView(selectedDate: $selectedDate)
                    .tag(TabViewIcons.transaction)
                
                SettingsView()
                    .tag(TabViewIcons.settings)
            }
            
            tabView
             */
            
            
            TabView(selection: $selectedTabIndex) {
                
                Tab("transaction", systemImage: "list.bullet.rectangle.fill", value: 0) {
                    TransactionView(selectedDate: $selectedDate)
                }
                
                Tab("settings", systemImage: "gearshape.fill", value: 1) {
                    SettingsView()
                }
                
                Tab(value: 2, role: .search) {
                    VStack {
                        NavigationView {
                            List {
                                Text("Search screen")
                            }
                            .navigationTitle("Search")
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                }
                
            }
            
            //.tabBarMinimizeBehavior(.onScrollDown)
            .tabViewBottomAccessory {
                Button("Add transaction") {
                    showNewTransactionModal = true
                }
            }
            .searchable(text: $searchText)
            
            .tint(Color.primaryTop)
        }
        .onAppear {
            /// Disable Swipe to go back when ResumeView is showing.
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
        .sheet(isPresented: $showNewTransactionModal) {
            AddModifyTransactionView(selectedDate: selectedDate)
        }
    }
    
//    var tabView: some View {
//        TabViewContainer {
//            showNewTransactionModal = true
//        } content: {
//            ForEach(TabViewIcons.allCases) { item in
//                
//                TabViewButton(selectedTab: $selectedTab, item: item)
//                    .padding(.horizontal, ConstantViews.paddingTabViewHorizontal)
//                    .padding(.bottom)
//                
//                if item == TabViewIcons.allCases.first {
//                    Spacer()
//                }
//            }
//        }
//    }
}

#Preview(Previews.localeES) {
    TabViewMain()
        .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    TabViewMain()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
