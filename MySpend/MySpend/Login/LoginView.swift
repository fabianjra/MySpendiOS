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
            
            Color.background //Background for full view.
            
            VStack {
                Text("mySpend")
                    .foregroundColor(Color.textPrimaryForeground)
                    .font(Font.custom(FontFamily.regular.rawValue,
                                      size: FontSizes.body))
                
                Text("Iniciar sesión")
                    .foregroundColor(Color.textPrimaryForeground)
                    .font(Font.custom(FontFamily.regular.rawValue,
                                      size: FontSizes.body))
                
                TextField("", text: $userEmail, prompt: Text("Email"))
                    .textFieldStyle(TextFieldIconStyle($userEmail, iconLeading: Image.envelopeFill))
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                
                SecureFieldShowPassword(placeHolder: "Password",
                                        text: $userPassword,
                                        iconLeading: Image.lockFill)
                
                ButtonPrimary(text: "Login") {
                    print("User: \(userEmail)")
                    print("Password: \(userPassword)")
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
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
