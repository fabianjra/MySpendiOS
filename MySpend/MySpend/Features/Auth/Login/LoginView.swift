//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @FocusState private var focusedField: Login.Field?
    
    @EnvironmentObject var authViewModel: AuthViewModel
 
    var body: some View {
        LogContainer {
            
            // MARK: HEADER
            HeaderNavigator(subTitle: "Log in to your account", onlyTitle: true)
                .padding(.bottom)
            
            
            // MARK: LOGIN
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldEmail(text: $viewModel.login.email,
                               errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .email)
                .onSubmit { login() }
                
                TextFieldPassword(text: $viewModel.login.password,
                                  errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .focused($focusedField, equals: .password)
                .onSubmit { login() }
                
                
                Button("Login") {
                    login()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                
                TextError(viewModel.errorMessage)
                
                
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
            .frame(maxWidth: ConstantFrames.iPadMaxWidth)
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
                TextPlain("New user?")
                
                Button("Create a new free account") {
                    Router.shared.path.append(Router.Destination.register)
                }
                .buttonStyle(ButtonLinkStyle())
            }
            .padding(.top)
        }
        .disabled(viewModel.isLoading)
        .onAppear {
            authViewModel.listenAuthentificationState()
        }
    }
    
    private func login() {
        Task {
            await viewModel.validateLogin()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
