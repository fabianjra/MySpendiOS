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
                    OnBoardingUsernameView()
                    
                case .onBoardinAccount:
                    OnBoardingAccountView().toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, showOnBoarding: Bool = false) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        UserDefaultsManager.userDefaults = .preview
        // Configuracion correcta para usar @AppStorage con preview:
        UserDefaultsManager.userDefaults.set(showOnBoarding, forKey: UserDefaultsKeys.isOnBoarding.rawValue)
    }
    var body: some View { RootView() }
}

#Preview("Normal \(Previews.localeES_CR)") {
    previewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Saturated \(Previews.localeEN_US)") {
    previewWrapper(.saturated)
        .environment(\.locale, .init(identifier: Previews.localeEN_US))
}


#Preview("Empty \(Previews.localeES_ES)") {
    previewWrapper(.empty)
        .environment(\.locale, .init(identifier: Previews.localeES_ES))
}

#Preview("OnBoarding \(Previews.localeES_CR)") {
    previewWrapper(.empty, showOnBoarding: true)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
