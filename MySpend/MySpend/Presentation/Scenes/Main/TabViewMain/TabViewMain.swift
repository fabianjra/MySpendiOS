//
//  TabViewMain.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct TabViewMain: View {
    
    @State var showNewTransactionModal = false
    @State var selectedTab: TabViewIcons = .transaction
    @State var navigateToHistory: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            /*
             Los tabView siempre estan cargadas en memoria, su totalidad de vistas,
             en este caso las 2 vistas estan cargadas en memoria.
             Por eso, se se hace scroll en la vista principal, se cambia de vista y luego vuelve,
             la vista permanece como quedó.
             */
            TabView(selection: $selectedTab) {
                
                /// Los tags permiten que las vistas cambien entre una seleccion u otra en el TabView.
                TransactionView()
                    .tag(TabViewIcons.transaction)
                
                SettingsView()
                    .tag(TabViewIcons.settings)
            }
            
            tabView
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            /// Disable Swipe to go back when ResumeView is showing.
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
        .sheet(isPresented: $showNewTransactionModal) {
            NewTransactionView()
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
    
    var tabView: some View {
        TabViewContainer {
            showNewTransactionModal = true
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
    TabViewMain()
        .environmentObject(AuthViewModel())
}