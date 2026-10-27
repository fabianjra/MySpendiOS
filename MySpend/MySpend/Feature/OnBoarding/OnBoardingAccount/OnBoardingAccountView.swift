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
    
    var body: some View {
        Form {
            Section {
                TextField(.accountInputNamePlaceHolder, text: $viewModel.accountName)
                    .formInputStyle($viewModel.accountName)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .onSubmit {
                        Task {
                            await viewModel.finishOnBoarding(withAccountName: true, accountManager: accountManager)
                        }
                    }
            } header: {
                //Text(.personalInformationInputNamePlaceholder)
            } footer: {
                Text(.onBoardingAccountNameOptionalInputMessage)
            }
        }
        .onAppear { isFocused = true }
        
        .navigationTitle(.onBoardingAccountTitle)
        .navigationSubtitle(.onBoardingAccountEntertName)
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    Task {
                        await viewModel.finishOnBoarding(withAccountName: true, accountManager: accountManager)
                    }
                } label: {
                    Text(.buttonContinue)
                        .padding(.vertical, ConstantViews.paddingButtonVertical)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                }
                .padding(.horizontal)
                .buttonStyle(.glass)
                .padding(.bottom)
                
                
                Button(.buttonSkip) {
                    Task {
                        await viewModel.finishOnBoarding(withAccountName: false, accountManager: accountManager)
                    }
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
        
        .toast($viewModel.toastResponse)
    }
}


#Preview(Previews.localeES) {
    
    @Previewable @State var previewAccountManager = AccountManager.shared
    
    NavigationStack {
        OnBoardingAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    
    @Previewable @State var previewAccountManager = AccountManager.shared
    
    NavigationStack {
        OnBoardingAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
