//
//  MainView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/7/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var resumeVM = ResumeViewModel()
    @State private var selectedTab: TabViewIcons = .resume
    
    @State private var showNewItemModal = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            /// Los tabView siempre estan cargadas en memoria, su totalidad de vistas,
            /// en este caso las 5 vistas estan cargadas en memoria.
            /// Por eso, se se hace scroll en la vista principal, se cambia de vista y luego vuelve,
            /// la vista permanece como quedó.
            TabView(selection: $selectedTab) {
                
                /// Los tags permiten que las vistas cambien entre una seleccion u otra en el TabView.
                ResumeView(viewModel: resumeVM)
                    .tag(TabViewIcons.resume)
                
                SettingsView()
                    .tag(TabViewIcons.settings)
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
    VStack {
        let path = Router()
        MainView()
            .environmentObject(path)
    }
}
