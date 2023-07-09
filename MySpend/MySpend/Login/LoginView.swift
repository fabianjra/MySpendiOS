//
//  LoginView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    
    @State private var errorMessage: String = ""
    @State private var canLogin: Bool = false
    @State private var goToRegister: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    
                    //MARK: TITLE
                    VStack(spacing: Views.textSpacing) {
                        Text("mySpend")
                            .foregroundColor(Color.textPrimaryForeground)
                            .font(Font.custom(FontFamily.thin.rawValue,
                                              size: FontSizes.bigXXXL))
                        
                        Text("Iniciar sesión")
                            .foregroundColor(Color.textPrimaryForeground)
                            .font(Font.custom(FontFamily.light.rawValue,
                                              size: FontSizes.body))
                    }
                    .padding(.bottom)
                    
                    
                    //MARK: LOGIN SECTION:
                    VStack(spacing: Views.formSpacing) {
                        
                        TextField("",
                                  text: $userEmail,
                                  prompt: Text("Email").foregroundColor(.textFieldPlaceholder))
                        .textFieldStyle(TextFieldIconStyle(iconLeading: Image.envelopeFill))
                        .onChange(of: userEmail) { _ in errorMessage = "" }
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                        
                        
                        SecureField("",
                                    text: $userPassword,
                                    prompt: Text("Password").foregroundColor(.textFieldPlaceholder))
                        .textFieldStyle(TextFieldIconStyle(iconLeading: Image.lockFill))
                        .onChange(of: userPassword) { _ in errorMessage = "" }
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.asciiCapable) //This avoids suggestions bar on the keyboard.
                        
                        
                        Button("Login") {
                            print("User: \(userEmail)")
                            print("Password: \(userPassword)")
                            
                            if userEmail.isEmpty || userPassword.isEmpty {
                                canLogin = false
                            } else {
                                canLogin = true
                            }
                            
                            if canLogin == false {
                                errorMessage = "Fill the text fields requireds"
                            }
                        }
                        .buttonStyle(ButtonPrimaryStyle())
                        .padding(.bottom)
                        .navigationDestination(isPresented: $canLogin) {
                            MainView()
                        }
                        
                        
                        Text("Error al ingresar")
                            .modifier(Show(isVisible: !errorMessage.isEmpty))
                            .foregroundColor(Color.textErrorForeground)
                            .font(.custom(FontFamily.semibold.rawValue, size: FontSizes.body))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                        
                        Button("Forgot password") {
                            print("Forgot password pressed")
                        }
                        .buttonStyle(ButtonLinkStyle())
                    }
                    .padding(.bottom)
                    
                    
                    //MARK: DIVISION:
                    Divider()
                        .frame(height: Frames.dividerHeight)
                        .overlay(Color.divider)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    
                    //MARK: REGISTER SECTION:
                    VStack {
                        
                        Button("Register") {
                            print("User: \(userEmail)")
                            print("Password: \(userPassword)")
                            errorMessage = "Error al ingresar"
                            goToRegister = true
                        }
                        .buttonStyle(ButtonPrimaryStyle())
                        .padding(.bottom)
                        .padding(.horizontal, Views.paddingSmallButton)
                        .navigationDestination(isPresented: $goToRegister) {
                            RegisterView()
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
                .padding()
                .background(LinearGradient(colors: Color.backgroundFormGradiant,
                                           startPoint: .leading,
                                           endPoint: .trailing))
                .cornerRadius(Radius.corners)
                .padding()
                .shadow(color: .shadow,
                        radius: Radius.shadow,
                        x: .zero, y: .zero)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
