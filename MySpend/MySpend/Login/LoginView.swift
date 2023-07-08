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
    
    var body: some View {
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                
                //MARK: Title
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
                
                //MARK: LOGIN FORM:
                VStack(spacing: Views.formSpacing) {
                    
                    TextField("",
                              text: $userEmail,
                              prompt: Text("Email").foregroundColor(.textFieldPlaceholder))
                    .textFieldStyle(TextFieldIconStyle(iconLeading: Image.envelopeFill))
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)

                    
                    SecureField("",
                                text: $userPassword,
                                prompt: Text("Password").foregroundColor(.textFieldPlaceholder))
                    .textFieldStyle(TextFieldIconStyle(iconLeading: Image.lockFill))
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.asciiCapable) //This avoids suggestions bar on the keyboard.
                    
                    Button("Login") {
                        print("User: \(userEmail)")
                        print("Password: \(userPassword)")
                    }
                    .buttonStyle(ButtonPrimaryStyle())
                }
                
                
                //            Button {
                //                //TODO: Action Forget password
                //                print("¿Olvidaste tu contraseña?")
                //            } label: {
                //                Text("¿Olvidaste tu contraseña?")
                //            }
                //
                //            //TODO: View Line separator
                //
                //            ButtonPrimary(text: "Registrarse") {
                //                print("Registrarse")
                //            }
                //            .padding(.horizontal, 100)
                //
                //            Text("Loguearse con")
                //
                //            HStack {
                //                Button {
                //                    //TODO: Login social network
                //                } label: {
                //                    Text("Facebook")
                //                }
                //
                //                Button {
                //                    //TODO: Login social network
                //                } label: {
                //                    Text("Twitter")
                //                }
                //
                //                Button {
                //                    //TODO: Login social network
                //                } label: {
                //                    Text("Google")
                //                }
                //            }
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
