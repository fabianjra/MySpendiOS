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
    
    var body: some View {
        FormContainer {
            
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
                
                
                TextFieldPassword(text: $userPasswordConfirm,
                                  isError: $isUserPasswordConfirmError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.checkmark)
                .textContentType(.newPassword)
                .padding(.bottom)
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
            }
        }
    }
    
    private func register() {
        print("User: \(userName)")
        print("Email: \(userEmail)")
        print("Password: \(userPassword)")
        print("Password confirm: \(userPasswordConfirm)")
        
        if userName.isEmptyOrWhitespace() || userEmail.isEmptyOrWhitespace() ||
            userPassword.isEmptyOrWhitespace() || userPasswordConfirm.isEmptyOrWhitespace() {
            canSubmit = false
            errorMessage = "Fill all the text fields"
        } else {
            canSubmit = true
        }
        
        //If Textfields are empty, bool error will be true.
        isUserNameError = userName.isEmptyOrWhitespace()
        isUserEmailError = userEmail.isEmptyOrWhitespace()
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        isUserPasswordConfirmError = userPasswordConfirm.isEmptyOrWhitespace()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
