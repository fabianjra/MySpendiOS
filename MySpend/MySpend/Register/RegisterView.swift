//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    @State private var userPasswordConfirm: String = ""
    
    @State private var errorMessage: String = ""
    
    var body: some View {
        
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
                    
                    Text("Register")
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
                    
                    
                    Button("Register") {
                        
                    }
                    .buttonStyle(ButtonPrimaryStyle())
                    .padding(.bottom)
                    
                    
                    Text("Error al ingresar")
                        .modifier(Show(isVisible: !errorMessage.isEmpty))
                        .foregroundColor(Color.textErrorForeground)
                        .font(.custom(FontFamily.semibold.rawValue, size: FontSizes.body))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    
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
                    
                    Button("Go back") {
                        
                    }
                    .buttonStyle(ButtonPrimaryStyle())
                    .padding(.bottom)
                    .padding(.horizontal, Views.paddingSmallButton)
                }
            }
            .modifier(FormStyle())
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
