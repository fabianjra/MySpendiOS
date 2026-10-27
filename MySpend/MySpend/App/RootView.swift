//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//
import SwiftUI

struct RootView: View {
    
    // MARK: MANAGERS
    @State private var accountManager = AccountManager.shared
    @State private var categoryManager = CategoryManager.shared
    
    @State private var themeManager = ThemeManager.shared
    @State private var router = Router.shared
    
    
    @AppStorage(UserDefaultsKeys.isOnBoarding.rawValue,
                store: UserDefaultsManager.userDefaults)
    private var isOnboarding: Bool = true
    
    /**
     Determines whether the onboarding flow should be displayed.

     The launch argument overrides the visual flow only in Debug,
     without modifying the user's persisted onboarding state.
     */
    private var shouldShowOnboarding: Bool {
        AppLaunchConfiguration.showOnboarding || isOnboarding
    }
    
    var body: some View {
        ZStack {
            if shouldShowOnboarding {
                
                NavigationStack(path: $router.onboardingPath) {
                    OnBoardingUsernameView()
                        .navigationDestination(for: Router.Destination.self) { destination in
                            switch destination {
                            case .onBoardinAccount:
                                OnBoardingAccountView()
                                
                            default:
                                EmptyView()
                            }
                        }
                }
                
            } else {
                NavigationStack(path: $router.path) {
                    TransactionView()
                        .navigationDestination(for: Router.Destination.self) { destination in
                            switch destination {
                            case .settings:
                                SettingsView()
                                
                            default:
                                EmptyView()
                            }
                        }
                }
            }
        }
        .animation(.default, value: shouldShowOnboarding)
        
        .onAppear {
            //UIApplication.shared.addTapGestureRecognizer()
        }
        .environment(accountManager)
        .environment(categoryManager)
        
        .environment(themeManager)
        .preferredColorScheme(themeManager.theme.colorScheme)
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, showOnBoarding: Bool = false) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        // Configuracion correcta para usar @AppStorage con preview:
        UserDefaultsManager.userDefaults.set(showOnBoarding, forKey: UserDefaultsKeys.isOnBoarding.rawValue)
    }
    var body: some View { RootView() }
}

#Preview(Previews.localeES_CR) {
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
