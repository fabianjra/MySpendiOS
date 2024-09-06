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
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Register new user")
                .padding(.bottom)
            
            
            // MARK: REGISTER
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldName(text: $viewModel.register.name,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }
                
                
                TextFieldEmail(text: $viewModel.register.email,
                               errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $viewModel.register.password,
                                  errorMessage: $viewModel.errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit { focusedField = .passwordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm password",
                                  text: $viewModel.register.passwordConfirm,
                                  errorMessage: $viewModel.errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .passwordConfirm)
                .submitLabel(.done)
                .onSubmit {
                    registerNewUser()
                }
                
                
                Button("Register") {
                    registerNewUser()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.bottom)
                
                
                TextError(message: viewModel.errorMessage)
            }
        }
        .disabled(viewModel.isLoading)
    }
    
    private func registerNewUser() {
        Task {
            focusedField = .none
            let response = await viewModel.validateRegister()
            
            if response.status.isSuccess {
                Router.shared.path.append(Router.Destination.main)
            } else {
                viewModel.errorMessage = response.message
            }
        }
    }
}

#Preview {
    RegisterView()
}
