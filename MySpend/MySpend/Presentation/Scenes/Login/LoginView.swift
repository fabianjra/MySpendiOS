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
        LogContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Log in to your account", onlyTitle: true)
                .padding(.bottom)
            
            
            // MARK: LOGIN
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldEmail(text: $loginVM.login.email,
                               errorMessage: $loginVM.errorMessage)
                .focused($focusedField, equals: .email)
                .onSubmit { login() }
                
                TextFieldPassword(text: $loginVM.login.password,
                                  errorMessage: $loginVM.errorMessage)
                .padding(.bottom)
                .focused($focusedField, equals: .password)
                .onSubmit { login() }
                
                
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
            .modifier(AddKeyboardToolbar(focusedField: $focusedField))
            
            
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
                    Image("apple")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: FrameSize.width.socialNetwork,
                               height: FrameSize.height.socialNetwork)
                        .padding()
                        .shadow(radius: ConstantRadius.shadow)
                    
                    Image("facebook")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: FrameSize.width.socialNetwork,
                               height: FrameSize.height.socialNetwork)
                        .padding()
                        .shadow(radius: ConstantRadius.shadow)
                    
                    Image("google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: FrameSize.width.socialNetwork,
                               height: FrameSize.height.socialNetwork)
                        .padding()
                        .shadow(radius: ConstantRadius.shadow)
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
    }
    
    private func login() {
        Task {
            await loginVM.validateLogin()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
