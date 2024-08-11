//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

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
                                  errorMessage: $changePasswordVM.model.errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.password)
                .focused($focusedField, equals: .userPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPassword }
                
                
                TextFieldPassword(placeHolder: "New password",
                                  text: $changePasswordVM.model.userNewPassword,
                                  errorMessage: $changePasswordVM.model.errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPasswordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm new password",
                                  text: $changePasswordVM.model.userNewPasswordConfirm,
                                  errorMessage: $changePasswordVM.model.errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPasswordConfirm)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = .none
                    Task {
                        await changePasswordVM.validateChangePassword()
                    }
                }
                
                
                Button("Change password") {
                    focusedField = .none
                    Task {
                        await changePasswordVM.validateChangePassword()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $changePasswordVM.isLoading))
                .disabled(changePasswordVM.model.disabled)
                .padding(.bottom)
                
                
                TextError(message: changePasswordVM.model.errorMessage)
            }
        }
        .disabled(changePasswordVM.isLoading)
        .onAppear {
            changePasswordVM.onAppear()
        }
    }
}

#Preview {
    ChangePasswordView()
}
