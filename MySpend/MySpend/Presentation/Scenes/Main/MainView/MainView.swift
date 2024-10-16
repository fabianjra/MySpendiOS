//
//  MainView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
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
            TabView(selection: $viewModel.selectedTab) {
                
                /// Los tags permiten que las vistas cambien entre una seleccion u otra en el TabView.
                ResumeView()
                    .tag(TabViewIcons.resume)
                
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
        .sheet(isPresented: $viewModel.showNewTransactionModal) {
            NewTransactionView()
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
    
    var tabView: some View {
        TabViewContainer {
            viewModel.showNewTransactionModal = true
        } content: {
            ForEach(TabViewIcons.allCases, id: \.id) { item in
                
                TabViewButton(selectedTab: $viewModel.selectedTab, item: item)
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
    MainView()
        .environmentObject(AuthViewModel())
}
