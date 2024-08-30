//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

//TODO: Como hacer para pasar una variable a una vista en un ENUM.
//enum Vistas: Hashable, View {
//    case Register
//    case MainView(TabViewIcons)
//    
//    var body: some View {
//        switch self {
//        case .Register:
//            RegisterView()
//        case .MainView(let selectedTab):
//            Vistas.MainView(selectedTab)
//        }
//    }
//}

struct RootView: View {
    
    @State private var isUserLoged = false
    @StateObject var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                if isUserLoged {
                    MainView()
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
            .navigationDestination(for: Router.Destination.self) { destination in
                switch destination {
                case .main:
                    MainView()
                        .toolbar(.hidden)
                case .register:
                    RegisterView()
                        .toolbar(.hidden)
                case .history:
                    HistoryView()
                        .toolbar(.hidden)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
