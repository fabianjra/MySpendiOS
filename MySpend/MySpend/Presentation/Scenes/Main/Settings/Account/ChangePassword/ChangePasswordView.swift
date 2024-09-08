//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject private var changePasswordVM = ChangePasswordViewModel()
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
                                  text: $changePasswordVM.model.userPassword,
                                  errorMessage: $changePasswordVM.errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.password)
                .focused($focusedField, equals: .userPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPassword }
                
                
                TextFieldPassword(placeHolder: "New password",
                                  text: $changePasswordVM.model.userNewPassword,
                                  errorMessage: $changePasswordVM.errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPasswordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm new password",
                                  text: $changePasswordVM.model.userNewPasswordConfirm,
                                  errorMessage: $changePasswordVM.errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPasswordConfirm)
                .submitLabel(.done)
                .onSubmit {
                    changePassword()
                }
                
                
                Button("Change password") {
                    changePassword()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $changePasswordVM.isLoading))
                .disabled(changePasswordVM.disabled)
                
                
                TextError(message: changePasswordVM.errorMessage)
            }
        }
        .disabled(changePasswordVM.isLoading)
        .onAppear {
            changePasswordVM.onAppear()
        }
    }
    
    private func changePassword() {
        Task {
            await changePasswordVM.validateChangePassword()
        }
    }
}

#Preview {
    ChangePasswordView()
}
