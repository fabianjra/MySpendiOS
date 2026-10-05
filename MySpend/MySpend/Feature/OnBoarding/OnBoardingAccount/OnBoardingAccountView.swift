//
//  OnBoardingAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingAccountView: View {
    
    @Environment(AccountManager.self) private var accountManager
    
    @StateObject private var viewModel = OnBoardingAccountViewModel()
    @FocusState private var focusedField: OnBoardingAccountViewModel.Field?
    
    var body: some View {
        VStack(spacing: ConstantViews.formSpacing) {
            
            TextFieldName(placeHolder: "Account name",
                          text: $viewModel.accountName,
                          iconLeading: nil,
                          errorMessage: $viewModel.errorMessage)
            .focused($focusedField, equals: .accountName)
            .onSubmit {
                Task {
                    await viewModel.finishOnBoarding(withAccountName: true, accountManager: accountManager)
                }
            }
            
            Button {
                Task {
                    await viewModel.finishOnBoarding(withAccountName: true, accountManager: accountManager)
                }
            } label: {
                Text(.buttonContinue)
                    .padding(.vertical, ConstantViews.paddingButtonVertical)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .buttonStyle(.glass)
            
            
            Button {
                Task {
                    await viewModel.finishOnBoarding(withAccountName: false, accountManager: accountManager)
                }
            } label: {
                Text(.buttonSkip)
                    .textStyle
            }
            
            Text(viewModel.errorMessage)
                .textErrorStyle
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(.onBoardingAccountTitle)
        .navigationSubtitle(.onBoardingAccountEntertName)
        .background(Color.backgroundGradient)
        .onAppear { focusedField = .accountName }
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
