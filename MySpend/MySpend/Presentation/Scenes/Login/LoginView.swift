//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginVM = LoginViewModel()
    @FocusState private var focusedField: Login.Field?
    
    @EnvironmentObject var authViewModel: AuthViewModel
 
    var body: some View {
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Log in to your account", onlyTitle: true)
                .padding(.bottom)
            
            
            // MARK: LOGIN
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldEmail(text: $loginVM.login.email,
                               errorMessage: $loginVM.errorMessage)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                
                
                TextFieldPassword(text: $loginVM.login.password,
                                  errorMessage: $loginVM.errorMessage,
                                  iconLeading: Image.lockFill)
                .padding(.bottom)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    login()
                }
                
                
                Button("Login") {
                    login()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $loginVM.isLoading))
                
                TextError(message: loginVM.errorMessage)
                
                
                Button("Forgot password?") {
                    print("Forgot password pressed")
                }
                .buttonStyle(ButtonLinkStyle())
                .padding(.bottom)   
            }

            
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
            .padding(.bottom)
            
            // MARK: REGISTER
            VStack {
                TextPlain(message: "New user?")
                
                Button("Create a new free account") {
                    Router.shared.path.append(Router.Destination.register)
                }
                .buttonStyle(ButtonLinkStyle())
            }
            .padding(.top)
        }
        .disabled(loginVM.isLoading)
        .onAppear {
            authViewModel.listenAuthentificationState()
        }
        
        //Add the "Done" button at the Top of the keyboard.
//        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                Button("Done") {
//                    focusedField = nil
//                }
//            }
//        }
    }
    
    private func login() {
        focusedField = .none
        Task {
            await loginVM.validateLogin()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
