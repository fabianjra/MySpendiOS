//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

struct ChangePasswordView: View {
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var userNewPassword: String = ""
    @State private var isUserNewPasswordError: Bool = false
    
    @State private var userNewPasswordConfirm: String = ""
    @State private var isUserNewPasswordConfirmError: Bool = false
    
    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var user = Auth.auth().currentUser
    
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
                .submitLabel(.done)
                .onSubmit { changePassword() }
                
                
                TextFieldPassword(placeHolder: "New password",
                                  text: $userNewPassword,
                                  isError: $isUserNewPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .submitLabel(.done)
                .onSubmit { changePassword() }
                
                
                TextFieldPassword(placeHolder: "Confirm new password",
                                  text: $userNewPasswordConfirm,
                                  isError: $isUserNewPasswordConfirmError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .submitLabel(.done)
                .onSubmit { changePassword() }
                
                
                Button("Change password") {
                    changePassword()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                
                
                TextError(message: errorMessage)
            }
        }
        .onAppear {
            guard user != nil else {
                errorMessage = ErrorMessages.userNotLoggedIn.localizedDescription
                return
            }
        }
    }
    
    private func changePassword() {
        
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserNewPasswordError = userNewPassword.isEmptyOrWhitespace()
        isUserNewPasswordConfirmError = userNewPasswordConfirm.isEmptyOrWhitespace()
        
        if isUserPasswordError || isUserNewPasswordError ||
            isUserNewPasswordConfirmError {
            canSubmit = false
            errorMessage = ErrorMessages.emptySpaces.localizedDescription
            return
        }
        
        if userNewPassword != userNewPasswordConfirm {
            errorMessage = ErrorMessages.newPasswordIsDifferent.localizedDescription
            return
        }
        
        SessionStore.updatePassword(actualPassword: userPassword,
                                    newPasword: userNewPasswordConfirm) { success, error in
            
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
