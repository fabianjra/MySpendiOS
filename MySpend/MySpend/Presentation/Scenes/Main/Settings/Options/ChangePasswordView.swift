//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var userNewPassword: String = ""
    @State private var isUserNewPasswordError: Bool = false
    
    @State private var userNewPasswordConfirm: String = ""
    @State private var isUserNewPasswordConfirmError: Bool = false

    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        FormContainer {
            
            //MARK: HEADER
            HStack {
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                TextTitleForm(title: "Change password",
                              titleWeight: .regular,
                              titleSize: .bigXL,
                              subTitle: "Fill the passwords spaces",
                              subTitleWeight: .regular)
                
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
            .padding(.bottom)
            
            
            //MARK: FIELDS
            VStack(spacing: Views.formSpacing) {
                
                TextFieldPassword(text: $userPassword,
                                  isError: $isUserPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.password)
                .submitLabel(.done)
                .onSubmit { changePassword() }
                
                
                TextFieldPassword(text: $userNewPassword,
                                  isError: $isUserNewPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .submitLabel(.done)
                .onSubmit { changePassword() }
                
                
                TextFieldPassword(text: $userNewPasswordConfirm,
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
    }
    
    private func changePassword() {
        print("User password: \(userPassword)")
        print("User new password: \(userNewPassword)")
        print("User new password confirm: \(userNewPasswordConfirm)")
        
        if userPassword.isEmptyOrWhitespace() || userNewPassword.isEmptyOrWhitespace() ||
            userNewPasswordConfirm.isEmptyOrWhitespace() {
            canSubmit = false
            errorMessage = ErrorMessages.emptySpaces.localizedDescription
        } else {
            canSubmit = true
        }
        
        //If Textfields are empty, bool error will be true.
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserNewPasswordError = userNewPassword.isEmptyOrWhitespace()
        isUserNewPasswordConfirmError = userNewPasswordConfirm.isEmptyOrWhitespace()
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
