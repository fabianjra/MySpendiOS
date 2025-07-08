//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//
import SwiftUI

struct RootView: View {
    
    @StateObject var router = Router.shared
    
    @AppStorage(UserDefaultsKeys.isOnBoarding.rawValue)
    private var isOnboarding: Bool = true
    
    var body: some View {
        NavigationStack(path: $router.path) { //TODO: REMOVER. No es necesario. Usar navigationLink
            VStack {
                if isOnboarding {
                    OnBoardingUsernameView()
                } else {
                    withAnimation { //TODO: Comprobar si funciona para que el TabView se vea de forma suave despues del OnBoarding
                        TabViewMain()
                    }
                }
            }
            .onAppear {
                UIApplication.shared.addTapGestureRecognizer()
            }
            .navigationDestination(for: Router.Destination.self) { destination in
                switch destination {
                case .onBoardingAccount:
                    OnBoardingAccountView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
