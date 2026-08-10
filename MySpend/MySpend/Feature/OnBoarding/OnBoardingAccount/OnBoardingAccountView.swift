//
//  OnBoardingAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingAccountView: View {
    
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
                    await viewModel.finishOnBoarding(withAccountName: true)
                }
            }
            
            Button {
                Task {
                    await viewModel.finishOnBoarding(withAccountName: true)
                }
            } label: {
                Text(.buttonContinue)
                    .padding(.vertical, ConstantViews.paddingButtonTransaction)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .buttonStyle(.glass)
            
            
            Button {
                Task {
                    await viewModel.finishOnBoarding(withAccountName: false)
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
        .background(Color.backgroundContentGradient)
        .onAppear { focusedField = .accountName }
    }
}

#Preview(Previews.localeES) {
    NavigationStack {
        OnBoardingAccountView()
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    NavigationStack {
        OnBoardingAccountView()
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
