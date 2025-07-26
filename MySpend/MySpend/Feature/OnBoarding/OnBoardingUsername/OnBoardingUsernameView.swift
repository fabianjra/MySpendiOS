//
//  OnBoardingView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingUsernameView: View {
    
    @StateObject private var viewModel = OnBoardingUsernameViewModel()
    @FocusState private var focusedField: OnBoardingUsernameViewModel.Field?
    
    var body: some View {
        LogContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "onboarding.title", onlyTitle: true)
                .padding(.bottom)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextPlain("Enter your username to start", family: .light, size: .big)
                
                
                TextFieldName(text: $viewModel.userName,
                              iconLeading: nil,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .userName)
                .onSubmit { viewModel.continueToNextStep(withName: true)}
                
                
                Button("Continue") {
                    viewModel.continueToNextStep(withName: true)
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                
                Button("Do it later") {
                    viewModel.continueToNextStep(withName: false)
                }
                .buttonStyle(ButtonLinkStyle())
                .padding(.bottom)
                
                
                TextError(viewModel.errorMessage)
            }
            .modifier(AddKeyboardToolbar(focusedField: $focusedField))
        }
        .onAppear {
            focusedField = .userName
        }
    }
}

#Preview("es") {
    OnBoardingUsernameView()
        .environment(\.locale, .init(identifier: "es"))
}

#Preview("en_US") {
    OnBoardingUsernameView()
        .environment(\.locale, .init(identifier: "en"))
}
