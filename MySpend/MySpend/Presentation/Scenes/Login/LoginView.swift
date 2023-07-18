//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false
    
    @State private var userPassword: String = ""
    @State private var isUserPasswordError: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var canLogin: Bool = false
    @State private var goToRegister: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .top) {

                VStack {
                    
                    TextTitleForm(subTitle: "Log in to your account")
                        .padding(.bottom)
                    
                    //MARK: LOGIN
                    VStack(spacing: Views.formSpacing) {

                        TextFieldEmail(text: $userEmail,
                                       isError: $isUserEmailError,
                                       errorMessage: $errorMessage)
                        
                        TextFieldPassword(text: $userPassword,
                                          isError: $isUserPasswordError,
                                          errorMessage: $errorMessage,
                                          iconLeading: Image.lockFill)
                        
                        
                        Button("Login") {
                            print("User: \(userEmail)")
                            print("Password: \(userPassword)")
                            
                            if userEmail.isEmpty || userPassword.isEmpty {
                                canLogin = false
                                errorMessage = "Fill the text fields required"
                            } else {
                                canLogin = true
                            }

                            //If Textfields are empty, bool error will be true.
                            isUserEmailError = userEmail.isEmpty
                            isUserPasswordError = userPassword.isEmpty
                        }
                        .buttonStyle(ButtonPrimaryStyle())
                        .padding(.bottom)
                        .navigationDestination(isPresented: $canLogin) {
                            TabViewCustom(selectedTab: .resume)
                                .toolbar(.hidden, for: .navigationBar)
                        }
                        
                        
                        Text(errorMessage)
                            .modifier(Show(isVisible: !errorMessage.isEmpty))
                            .foregroundColor(Color.textErrorForeground)
                            .font(.custom(FontFamily.semibold.rawValue, size: FontSizes.body))
                            .multilineTextAlignment(.center)
                            .lineLimit(Views.messageMaxLines)
                        
                        Button("Forgot password") {
                            print("Forgot password pressed")
                        }
                        .buttonStyle(ButtonLinkStyle())
                    }
                    .padding(.bottom)
                    
                    
                    //MARK: DIVISION
                    DividerView()
                        .padding(.bottom)
                    
                    
                    //MARK: REGISTER
                    VStack {
                        
                        Button("Register") {
                            print("User: \(userEmail)")
                            print("Password: \(userPassword)")
                            goToRegister = true
                        }
                        .buttonStyle(ButtonPrimaryStyle())
                        .padding(.bottom)
                        .padding(.horizontal, Views.paddingSmallButton)
                        .navigationDestination(isPresented: $goToRegister) {
                            RegisterView()
                                .toolbar(.hidden, for: .navigationBar)
                        }
                        
                        
                        Text("Login with")
                            .foregroundColor(Color.textSecondaryForeground)
                            .font(Font.custom(FontFamily.regular.rawValue,
                                              size: FontSizes.body))
                        
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
                .modifier(FormStyleSign())
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
