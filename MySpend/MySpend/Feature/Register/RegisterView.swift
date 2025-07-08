//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    @FocusState private var focusedField: Register.Field?
    
    var body: some View {
        LogContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Register new user")
                .padding(.bottom)
            
            
            // MARK: REGISTER
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldName(text: $viewModel.register.name,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { registerNewUser() }
                
                
                TextFieldEmail(text: $viewModel.register.email,
                               errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .email)
                .onSubmit { registerNewUser() }
                
                
                TextFieldPassword(text: $viewModel.register.password,
                                  errorMessage: $viewModel.errorMessage)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .onSubmit { registerNewUser() }
                
                
                TextFieldPassword(placeHolder: "Confirm password",
                                  text: $viewModel.register.passwordConfirm,
                                  iconLeading: Image.checkmark,
                                  errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .passwordConfirm)
                .onSubmit { registerNewUser() }
                
                
                Button("Register") {
                    registerNewUser()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                
                
                TextError(viewModel.errorMessage)
            }
            .modifier(AddKeyboardToolbar(focusedField: $focusedField))
        }
        .disabled(viewModel.isLoading)
    }
    
    private func registerNewUser() {
        Task {
            let response = await viewModel.validateRegister()
            
            if response.status.isSuccess {
                //Router.shared.path.append(Router.Destination.main)
            } else {
                viewModel.errorMessage = response.message
            }
        }
    }
}

#Preview {
    RegisterView()
}
