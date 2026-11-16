//
//  RootView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//
import SwiftUI

struct RootView: View {
    
    @State private var router = Router.shared
    
    // MARK: - SETTINGS MANAGERS
    @State private var themeManager = ThemeManager.shared
    @State private var dateTimeIntervalManager = DateTimeIntervalManager.shared
    @State private var currencyManager = CurrencyManager.shared
    
    
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
        .environment(dateTimeIntervalManager)
        .environment(currencyManager)
        .environment(themeManager)
        .preferredColorScheme(themeManager.theme.colorScheme)
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, showOnBoarding: Bool = false) {
        _transactionManager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _categoryManager = State(initialValue: CategoryManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        
        // Configuracion correcta para usar @AppStorage con preview:
        UserDefaultsManager.userDefaults.set(showOnBoarding, forKey: UserDefaultsKeys.isOnBoarding.rawValue)
    }
    
    @State var transactionManager: TransactionManager
    @State var categoryManager: CategoryManager
    @State var accountManager: AccountManager
    
    var body: some View {
        RootView()
            .environment(transactionManager)
            .environment(categoryManager)
            .environment(accountManager)
    }
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
