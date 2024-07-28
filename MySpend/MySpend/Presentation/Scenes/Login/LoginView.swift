//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI
import Firebase

private enum Field: Hashable {
    case email
    case password
}

struct LoginView: View {
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var canSubmit: Bool = false
    @State private var goToRegister: Bool = false
    
    @State private var isLoading: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Log in to your account", onlyTitle: true)
                .padding(.bottom)
            
            
            // MARK: LOGIN
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldEmail(text: $userEmail,
                               isError: $isUserEmailError,
                               errorMessage: $errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $userPassword,
                                  isError: $isUserPasswordError,
                                  errorMessage: $errorMessage,
                                  iconLeading: Image.lockFill)
                .padding(.bottom)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit { validateLogin() }
                
                
                Button("Login") {
                    validateLogin()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
                .padding(.bottom)
                .navigationDestination(isPresented: $canSubmit) {
                    MainView(selectedTab: .resume)
                        .toolbar(.hidden)
                }
                
                
                TextError(message: errorMessage)
            }
            .padding(.bottom)
            
            
            // MARK: REGISTER & FORGOT PASSWORD
            VStack {
                
                Button("Forgot password?") {
                    print("Forgot password pressed")
                }
                .buttonStyle(ButtonLinkStyle())
                .padding(.bottom)
                
                Button("Register") {
                    goToRegister = true
                }
                .buttonStyle(ButtonPrimaryStyle(neverBgDisabled: true))
                .padding(.bottom)
                .padding(.horizontal, ConstantViews.paddingSmallButton)
                .navigationDestination(isPresented: $goToRegister) {
                    RegisterView()
                        .toolbar(.hidden)
                }
            }
            .padding(.bottom)
            
            
            // MARK: DIVISION
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
            
            
            // MARK: LOGIN SOCIAL NETWORKS
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
        .disabled(isLoading)
        
        //Add the "Done" button at the Top of the keyboard.
//        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                Button("Done") {
//                    focusedField = nil
//                }
//            }
//        }
    }
    
    private func validateLogin() {
        
        focusedField = .none
        
        //If Textfields are empty, bool error will be true.
        isUserEmailError = userEmail.isEmptyOrWhitespace()
        isUserPasswordError = userPassword.isEmptyOrWhitespace()
        
        if isUserEmailError || isUserPasswordError {
            errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        login()
    }
    
    private func login() {
        isLoading = true
        
        SessionStore.singIn(userEmail, password: userPassword) { success, error in
            defer {
                isLoading = false
            }
            
            if success {
                canSubmit = true
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
