//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI
import Firebase

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
    
    @State private var errorUpdateName: String = ""
    @State private var errorSendEmail: String = ""
    
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
                
                TextError(message: errorUpdateName)
                TextError(message: errorSendEmail)
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
            return
        }
        
        if userPassword.count < 6 || userPasswordConfirm.count < 6 {
            errorMessage = ErrorMessages.passwordIsShort.localizedDescription
            return
        }
        
        if userPassword != userPasswordConfirm {
            errorMessage = ErrorMessages.creationPasswordIsDifferent.localizedDescription
            return
        }
        
        Register()
    }
    
    private func Register() {
        SessionStore.registerUser(userEmail,
                                  password: userPassword) { success, user, error in
            if success {
                if let user = user {
                    updateName(user: user)
                    
                } else {
                    errorUpdateName = ErrorMessages.userCreatedNoName.localizedDescription
                    errorSendEmail = ErrorMessages.userCreatedNoSendEmail.localizedDescription
                }
                
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func updateName(user: User) {
        SessionStore.updateUserName(newUserName: userName,
                                    user: user) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
                errorUpdateName = ErrorMessages.userCreatedNoName.localizedDescription
                errorSendEmail = ErrorMessages.userCreatedNoSendEmail.localizedDescription
            } else {
                sendEmail(user: user)
            }
        }
    }
    
    private func sendEmail(user: User) {
        SessionStore.sendEmailValidation(user: user) { success, error in
            if success {
                canSubmit = true
            } else {
                errorMessage = error.localizedDescription
                errorSendEmail = ErrorMessages.userCreatedNoSendEmail.localizedDescription
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
