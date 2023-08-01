//
//  ChangePasswordView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

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
    
    @State private var user = Auth.auth().currentUser
    
    var body: some View {
        FormScrollContainer {
            
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
        
        let userEmail = user?.email ?? ""
        
        //EMAIL:
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: userPassword)
        
        //FACEBOOK:
        //let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.currentAccessToken().tokenString)
        
        //TWITTER:
        //let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
        
        //GOOGLE:
        //let authentication = user.authentication
        //let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        // Prompt the user to re-provide their sign-in credentials
        user?.reauthenticate(with: credential) { result, error in
            
            if let error = error {
                errorMessage = error.localizedDescription
                
            } else {
                user?.updatePassword(to: userNewPasswordConfirm) { error in
                    
                    if let error = error {
                        errorMessage = error.localizedDescription
                        
                    } else {
                        errorMessage = "PASSWORD CHANGED!"
                        canSubmit = true
                    }
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
