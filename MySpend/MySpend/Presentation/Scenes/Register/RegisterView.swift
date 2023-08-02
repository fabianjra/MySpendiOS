//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var userName: String = ""
    @State private var isUserNameError: Bool = false
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var userPasswordConfirm: String = ""
    @State private var isUserPasswordConfirmError: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var canSubmit: Bool = false
    
    @State private var errorMessageUpdateName: String = ""
    @State private var errorMessageSendEmail: String = ""
    
    var body: some View {
        FormScrollContainer {
            
            //MARK: HEADER
            HStack {
                
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                TextTitleForm(subTitle: "Register new user")
                    
                
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
            .padding(.bottom)
            
            //MARK: REGISTER
            VStack(spacing: Views.formSpacing) {
                
                TextFieldName(text: $userName,
                              isError: $isUserNameError,
                              errorMessage: $errorMessage)
                .submitLabel(.done)
                .onSubmit { register() }
                
                
                TextFieldEmail(text: $userEmail,
                               isError: $isUserEmailError,
                               errorMessage: $errorMessage)
                .submitLabel(.done)
                .onSubmit { register() }
                
                
                TextFieldPassword(text: $userPassword,
                                  isError: $isUserPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .textContentType(.newPassword)
                .submitLabel(.done)
                .onSubmit { register() }
                
                
                TextFieldPassword(placeHolder: "Confirm password",
                                  text: $userPasswordConfirm,
                                  isError: $isUserPasswordConfirmError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .padding(.bottom)
                .textContentType(.newPassword)
                .submitLabel(.done)
                .onSubmit { register() }
                
                
                Button("Register") {
                    register()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                .navigationDestination(isPresented: $canSubmit) {
                    MainView(selectedTab: .resume)
                        .toolbar(.hidden)
                }
                
                
                TextError(message: errorMessage)
                
                TextError(message: errorMessageUpdateName)
                TextError(message: errorMessageSendEmail)
            }
        }
    }
    
    private func register() {

        isUserNameError = userName.isEmptyOrWhitespace()
        isUserEmailError = userEmail.isEmptyOrWhitespace()
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserPasswordConfirmError = userPasswordConfirm.isEmptyOrWhitespace()
        
        if isUserNameError || isUserEmailError ||
            isUserPasswordError || isUserPasswordConfirmError {
            errorMessage = ErrorMessages.emptySpaces.localizedDescription
            
        } else {
            SessionStore.registerUser(userEmail,
                                      password: userPassword) { success, user, error in
                if success {
                    
                    if let user = user {
                        
                        //Add userName:
                        SessionStore.updateUserName(newUserName: userName,
                                                    user: user) { user, error in
                            if let error = error {
                                errorMessageUpdateName = error.localizedDescription
                            }
                        }
                        
                        //Send email verification:
                        SessionStore.sendEmailValidation(user: user) { success, error in
                            if success == false {
                                errorMessageSendEmail = error.localizedDescription
                            }
                        }
                        
                        canSubmit = true
                    } else {
                        errorMessageUpdateName = ErrorMessages.userCreatedWithoutName.localizedDescription
                        errorMessageSendEmail = ErrorMessages.userCreatedWithoutSendEmail.localizedDescription
                    }
                    
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
