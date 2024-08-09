//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

enum Vistas: Hashable, View {
    case Register
    case MainView(TabViewIcons)
    
    var body: some View {
        switch self {
        case .Register:
            RegisterView()
        case .MainView(let selectedTab):
            Vistas.MainView(selectedTab)
        }
    }
}

struct RootView: View {
    
    @State private var isUserLoged = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isUserLoged {
                    MainView(selectedTab: .resume)
                } else {
                    LoginView()
                }
            }
            .onAppear {
                UIApplication.shared.addTapGestureRecognizer()
                
                //Handle session for navigation.
                Auth.auth().addStateDidChangeListener { auth, user in
                    isUserLoged = user != nil
                }
                
                if Auth.auth().currentUser?.uid != nil {
                    //user is logged in
                } else {
                    //user is not logged in
                }
            }
        }
    }
}

#Preview {
    RootView()
}
