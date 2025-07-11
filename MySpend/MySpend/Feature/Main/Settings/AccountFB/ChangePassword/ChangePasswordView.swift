//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject private var viewModel = ChangePasswordViewModel()
    @FocusState private var focusedField: ChangePassword.Field?
    
    var body: some View {
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Change password",
                          titleWeight: .regular,
                          titleSize: .bigXL,
                          subTitle: "Fill the passwords spaces",
                          subTitleWeight: .regular)
            .padding(.bottom)
            
            
            // MARK: FIELDS
            VStack(spacing: ConstantViews.formSpacing) {
                TextFieldPassword(placeHolder: "Current password",
                                  text: $viewModel.model.userPassword,
                                  errorMessage: $viewModel.errorMessage)
                .textContentType(.password)
                .focused($focusedField, equals: .userPassword)
                .onSubmit { changePassword() }
                
                
                TextFieldPassword(placeHolder: "New password",
                                  text: $viewModel.model.userNewPassword,
                                  iconLeading: Image.checkmark,
                                  errorMessage: $viewModel.errorMessage)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPassword)
                .onSubmit { changePassword() }
                
                
                TextFieldPassword(placeHolder: "Confirm new password",
                                  text: $viewModel.model.userNewPasswordConfirm,
                                  iconLeading: Image.checkmark,
                                  errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPasswordConfirm)
                .onSubmit { changePassword() }
            }
            .modifier(AddKeyboardToolbar(focusedField: $focusedField))
            
            VStack {
                Button("Change password") {
                    changePassword()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .disabled(viewModel.disabled)
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .disabled(viewModel.isLoading)
        .onAppear {
            viewModel.validateCurrentUser()
        }
    }
    
    private func changePassword() {
        Task {
            await viewModel.validateChangePassword()
        }
    }
}

#Preview {
    ChangePasswordView()
}
