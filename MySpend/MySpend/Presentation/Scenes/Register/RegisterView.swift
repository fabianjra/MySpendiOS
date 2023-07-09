//
//  RegisterView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    @State private var userPasswordConfirm: String = ""
    
    @State private var errorMessage: String = ""
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                
                TextTitleForm(subTitle: "Register new user")
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
                    
                    
                    Text(errorMessage)
                        .modifier(Show(isVisible: !errorMessage.isEmpty))
                        .foregroundColor(Color.textErrorForeground)
                        .font(.custom(FontFamily.semibold.rawValue, size: FontSizes.body))
                        .multilineTextAlignment(.center)
                        .lineLimit(Views.messageMaxLines)
                    
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
                        dismiss()
                    }
                    .buttonStyle(ButtonPrimaryStyle(color: Color.secondaryGradiant))
                    .padding(.bottom)
                    .padding(.horizontal, Views.paddingSmallButton)
                }
            }
            .modifier(FormStyle())
            .padding(.top)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
