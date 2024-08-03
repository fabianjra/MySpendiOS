//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @StateObject var loginVM = LoginViewModel()
    @FocusState private var focusedField: Login.Field?
 
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Log in to your account", onlyTitle: true)
                .padding(.bottom)
            
            
            // MARK: LOGIN
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldEmail(text: $loginVM.login.email,
                               errorMessage: $loginVM.login.errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $loginVM.login.password,
                                  errorMessage: $loginVM.login.errorMessage,
                                  iconLeading: Image.lockFill)
                .padding(.bottom)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = .none
                    Task {
                        await loginVM.validateLogin()
                    }
                }
                
                
                Button("Login") {
                    focusedField = .none
                    Task {
                        await loginVM.validateLogin()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $loginVM.login.isLoading))
                .padding(.bottom)
                .navigationDestination(isPresented: $loginVM.login.canSubmit) {
                    MainView(selectedTab: .resume)
                        .toolbar(.hidden)
                }
                
                
                TextError(message: loginVM.login.errorMessage)
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
                    loginVM.login.navigateToRegisterView = true
                }
                .buttonStyle(ButtonPrimaryStyle(neverBgDisabled: true))
                .padding(.bottom)
                .padding(.horizontal, ConstantViews.paddingSmallButton)
                .navigationDestination(isPresented: $loginVM.login.navigateToRegisterView) {
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
        .disabled(loginVM.login.isLoading)
        
        //Add the "Done" button at the Top of the keyboard.
//        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                Button("Done") {
//                    focusedField = nil
//                }
//            }
//        }
    }
}

#Preview {
    LoginView()
}
