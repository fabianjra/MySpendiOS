//
//  OnBoardingAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingAccountView: View {
    
    @Environment(AccountManager.self) private var accountManager
    
    @State private var viewModel = OnBoardingAccountViewModel()
    @FocusState private var isFocused: Bool
    
    @AppStorage(UserDefaultsKeys.isOnBoarding.rawValue,
                store: UserDefaultsManager.userDefaults)
    private var isOnboarding: Bool = true
    
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        Form {
            Section {
                TextField(.accountInputNamePlaceHolder, text: $viewModel.accountName)
                    .formInputStyle($viewModel.accountName)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .onSubmit {
                        finishOnBoarding(withAccountName: true)
                    }
            } header: {
                //Text(.personalInformationInputNamePlaceholder)
            } footer: {
                Text(.onBoardingAccountNameOptionalInputMessage)
            }
        }
        .onAppear { isFocused = true }
        
        .navigationTitle(.onBoardingAccountTitle)
        .navigationSubtitle(.onBoardingAccountEnterName)
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    finishOnBoarding(withAccountName: true)
                } label: {
                    Text(.buttonContinue)
                        .padding(.vertical, ConstantViews.paddingButtonVertical)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                }
                .padding(.horizontal)
                .buttonStyle(.glass)
                .padding(.bottom)
                
                
                Button(.buttonSkip) {
                    isFocused = false
                    finishOnBoarding(withAccountName: false)
                }
                .foregroundStyle(.primary)
                .padding(.bottom)
            }
        }
        
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .background {
            Color.backgroundGradient
                .ignoresSafeArea(.container, edges: .all)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        
        .toast($toastResponse)
    }
    
    private func finishOnBoarding(withAccountName: Bool) {
        Task {
            toastResponse = await viewModel.finishOnBoarding(withAccountName: withAccountName, accountManager: accountManager)
            
            if toastResponse?.type != .error {
                isOnboarding = false
            }
        }
    }
}


#Preview(Previews.localeES) {
    
    @Previewable @State var previewAccountManager = AccountManager(viewContext: MockDataType.normal.viewContext)
    
    NavigationStack {
        OnBoardingAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    
    @Previewable @State var previewAccountManager = AccountManager(viewContext: MockDataType.normal.viewContext)
    
    NavigationStack {
        OnBoardingAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
