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
            HeaderNavigator(subTitle: "Welcome", onlyTitle: true)
                .padding(.bottom)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextPlain("Enter your username to start", family: .light, size: .big)
                
                
                TextFieldName(text: $viewModel.userName,
                              iconLeading: nil,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .userName)
                .onSubmit { viewModel.continueWithUserName() }
                
                
                Button("Continue") {
                    viewModel.continueWithUserName()
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                
                Button("Do it later") {
                    viewModel.continueWithoutUserName()
                }
                .buttonStyle(ButtonLinkStyle())
                .padding(.bottom)
                
                
                TextError(viewModel.errorMessage)
            }
            .modifier(AddKeyboardToolbar(focusedField: $focusedField))
        }
    }
}

#Preview {
    OnBoardingUsernameView()
}
