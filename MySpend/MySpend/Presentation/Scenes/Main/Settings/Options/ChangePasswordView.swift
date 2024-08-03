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
                                  text: $userPassword,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.password)
                .focused($focusedField, equals: .userPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPassword }
                
                
                TextFieldPassword(placeHolder: "New password",
                                  text: $userNewPassword,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPassword)
                .submitLabel(.next)
                .onSubmit { focusedField = .newPasswordConfirm }
                
                
                TextFieldPassword(placeHolder: "Confirm new password",
                                  text: $userNewPasswordConfirm,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPasswordConfirm)
                .submitLabel(.done)
                .onSubmit {
                    Task {
                        await validateChangePassword()
                    }
                }
                
                
                Button("Change password") {
                    Task {
                        await validateChangePassword()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
                .disabled(buttonDisabled)
                .padding(.bottom)
                
                
                TextError(message: errorMessage)
            }
        }
        .disabled(isLoading)
        .onAppear {
            if UtilsStore.getCurrentUser() == nil {
                buttonDisabled = true
                errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            }
        }
    }
    
    private func validateChangePassword() async {
        
        focusedField = .none
        
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserNewPasswordError = userNewPassword.isEmptyOrWhitespace()
        isUserNewPasswordConfirmError = userNewPasswordConfirm.isEmptyOrWhitespace()
        
        if isUserPasswordError || isUserNewPasswordError || isUserNewPasswordConfirmError {
            errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        if userNewPassword != userNewPasswordConfirm {
            errorMessage = ConstantMessages.newPasswordIsDifferent.localizedDescription
            return
        }
        
        do {
           try await changePassword()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func changePassword() async throws {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        try await SessionStore.updatePassword(actualPassword: userPassword, 
                                              newPasword: userNewPasswordConfirm)
        
        errorMessage = "PASSWORD CHANGED!"
        canSubmit = true
    }
}

#Preview {
    ChangePasswordView()
}
