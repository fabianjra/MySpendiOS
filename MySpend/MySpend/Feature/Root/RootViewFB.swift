//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI

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

struct RootViewFB: View {
    
    @StateObject var router = Router.shared
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                if authViewModel.currentUser != nil {
                    TabViewMain()
                } else {
                    LoginView()
                }
            }
            .onAppear {
                UIApplication.shared.addTapGestureRecognizer()
            }
            .navigationDestination(for: Router.Destination.self) { destination in
                switch destination {
                case .main:
                    TabViewMain() //For: When go from register.
                        .toolbar(.hidden, for: .navigationBar)
                case .register:
                    RegisterView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
}

#Preview {
    RootViewFB()
        .environmentObject(AuthViewModel())
}
