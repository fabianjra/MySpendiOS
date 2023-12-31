//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

private enum Field: Hashable {
    case userPassword
    case newPassword
    case newPasswordConfirm
}

struct ChangePasswordView: View {
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var userNewPassword: String = ""
    @State private var isUserNewPasswordError: Bool = false
    
    @State private var userNewPasswordConfirm: String = ""
    @State private var isUserNewPasswordConfirmError: Bool = false
    
    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var buttonDisabled: Bool = false
    @State private var isLoading: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Change password",
                          titleWeight: .regular,
                          titleSize: .bigXL,
                          subTitle: "Fill the passwords spaces",
                          subTitleWeight: .regular)
            .padding(.bottom)
            
            
            // MARK: FIELDS
            VStack(spacing: Views.formSpacing) {
                
                TextFieldPassword(placeHolder: "Current password",
                                  text: $userPassword,
                                  isError: $isUserPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.password)
                .focused($focusedField, equals: .userPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPassword }
                
                
                TextFieldPassword(placeHolder: "New password",
                                  text: $userNewPassword,
                                  isError: $isUserNewPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPasswordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm new password",
                                  text: $userNewPasswordConfirm,
                                  isError: $isUserNewPasswordConfirmError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPasswordConfirm)
                .submitLabel(.done)
                .onSubmit { validateChangePassword() }
                
                
                Button("Change password") {
                    validateChangePassword()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
                .disabled(buttonDisabled)
                .padding(.bottom)
                
                
                TextError(message: errorMessage)
            }
        }
        .disabled(isLoading)
        .onAppear {
            if SessionStore.getCurrentUser() == nil {
                buttonDisabled = true
                errorMessage = ErrorMessages.userNotLoggedIn.localizedDescription
            }
        }
    }
    
    private func validateChangePassword() {
        
        focusedField = .none
        
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserNewPasswordError = userNewPassword.isEmptyOrWhitespace()
        isUserNewPasswordConfirmError = userNewPasswordConfirm.isEmptyOrWhitespace()
        
        if isUserPasswordError || isUserNewPasswordError || isUserNewPasswordConfirmError {
            errorMessage = ErrorMessages.emptySpaces.localizedDescription
            return
        }
        
        if userNewPassword != userNewPasswordConfirm {
            errorMessage = ErrorMessages.newPasswordIsDifferent.localizedDescription
            return
        }
        
        changePassword()
    }
    
    private func changePassword() {
        isLoading = true
        
        SessionStore.updatePassword(actualPassword: userPassword,
                                    newPasword: userNewPasswordConfirm) { success, error in
            defer {
                isLoading = false
            }
            
            if success {
                errorMessage = "PASSWORD CHANGED!"
                canSubmit = true
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
