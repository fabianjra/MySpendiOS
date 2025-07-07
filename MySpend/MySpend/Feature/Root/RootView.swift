//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//
import SwiftUI

struct RootView: View {
    
    @StateObject var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                //TODO: Agregar vista de Onboarding, validar con UserDefault.
                TabViewMain()
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
                    EmptyView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
