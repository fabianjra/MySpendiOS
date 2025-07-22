//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//
import SwiftUI

struct RootView: View {
    
    @StateObject var router = Router.shared
    
    @AppStorage(UserDefaultsKeys.isOnBoarding.rawValue,
                store: UserDefaultsManager.userDefaults)
    private var isOnboarding: Bool = true
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                if isOnboarding {
                    OnBoardingUsernameView()
                } else {
                    TabViewMain()
                }
            }
            .onAppear {
                UIApplication.shared.addTapGestureRecognizer()
            }
            .navigationDestination(for: Router.Destination.self) { destination in
                switch destination {
                    
                case .mainView:
                    TabViewMain().toolbar(.hidden, for: .navigationBar)
                    
                case .onBoardingName:
                    OnBoardingAccountView().toolbar(.hidden, for: .navigationBar)
                    
                case .onBoardinAccount:
                    OnBoardingAccountView().toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
}


private struct previewWrapper: View {
    init() {
        UserDefaultsManager.userDefaults = .preview
        // Configuracion correcta para usar @AppStorage con preview:
        UserDefaultsManager.userDefaults.set(false, forKey: UserDefaultsKeys.isOnBoarding.rawValue)
    }
    var body: some View { RootView() }
}

#Preview("es_CR") {
    previewWrapper()
        .environment(\.locale, .init(identifier: "es_CR"))
}
