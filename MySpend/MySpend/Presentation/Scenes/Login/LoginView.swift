//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var canSubmit: Bool = false
    @State private var goToRegister: Bool = false
    
    var body: some View {
        FormScrollContainer {
            
            TextTitleForm(subTitle: "Log in to your account")
                .padding(.bottom)
            
            //MARK: LOGIN
            VStack(spacing: Views.formSpacing) {
                
                TextFieldEmail(text: $userEmail,
                               isError: $isUserEmailError,
                               errorMessage: $errorMessage)
                .submitLabel(.done)
                .onSubmit { login() }
                
                
                TextFieldPassword(text: $userPassword,
                                  isError: $isUserPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .padding(.bottom)
                .textContentType(.password)
                .submitLabel(.done)
                .onSubmit { login() }
                
                
                Button("Login") {
                    login()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                .navigationDestination(isPresented: $canSubmit) {
                    MainView(selectedTab: .resume)
                        .toolbar(.hidden)
                }
                
                
                TextError(message: errorMessage)
            }
            .padding(.bottom)
            
            
            //MARK: REGISTER & FORGOT PASSWORD
            VStack {
                
                Button("Forgot password?") {
                    print("Forgot password pressed")
                }
                .buttonStyle(ButtonLinkStyle())
                .padding(.bottom)
                
                Button("Register") {
                    goToRegister = true
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                .padding(.horizontal, Views.paddingSmallButton)
                .navigationDestination(isPresented: $goToRegister) {
                    RegisterView()
                        .toolbar(.hidden)
                }
            }
            .padding(.bottom)
            
            
            //MARK: DIVISION
            HStack {
                VStack {
                    DividerView()
                }
                
                Text("or")
                    .foregroundColor(Color.textSecondaryForeground)
                    .font(.montserrat())
                
                VStack {
                    DividerView()
                }
            }
            .padding(.bottom)
            
            
            //MARK: LOGIN SOCIAL NETWORKS
            VStack {
                Text("Login with")
                    .foregroundColor(Color.textSecondaryForeground)
                    .font(.montserrat())
                
                HStack {
                    //TODO: Add button for social networks
                    Image.envelopeFill
                        .padding()
                    
                    Image.lockFill
                        .padding()
                    
                    Image.envelopeFill
                        .padding()
                }
            }
        }
    }
    
    private func login() {

        //If Textfields are empty, bool error will be true.
        isUserEmailError = userEmail.isEmptyOrWhitespace()
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        
        if isUserEmailError || isUserPasswordError {
            errorMessage = ErrorMessages.emptySpaces.localizedDescription
            
        } else {
            SessionStore.singIn(userEmail, password: userPassword) { success, error in
                if success {
                    canSubmit = true
                } else {
                    errorMessage = error?.localizedDescription ??
                    ErrorMessages.generic.localizedDescription
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
