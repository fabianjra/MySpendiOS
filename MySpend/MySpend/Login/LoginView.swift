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
                    .font(Font.custom(MontserratFamily.regular.rawValue,
                                      size: FontSizes.body.size))
                
                Text("Iniciar sesión")
                    .font(Font.custom(MontserratFamily.regular.rawValue,
                                      size: FontSizes.body.size))
                
                TextField("", text: $userEmail)
                    .textFieldStyle(TextFieldIconStyle("Email", text:$userEmail, iconLeading: Image.envelopeFill))
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                
                SecureField("", text: $userPassword)
                    .textFieldStyle(TextFieldIconStyle("Password", text: $userPassword, iconLeading: Image.lockFill))
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.asciiCapable) // This avoids suggestions bar on the keyboard.
                
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
            .background(LinearGradient(colors: Color.backgroundGradiant,
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
