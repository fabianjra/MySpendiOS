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
        
        VStack {
            Text("mySpend")
                .font(Fonts.light)
            
            Text("Iniciar sesión")
                .font(Fonts.light)
            
            TextFieldIconLeading(placeHolder: "Correo electronico",
                                 text: $userEmail,
                                 icon: Image.userFill)
            
            TextField("Contraseña", text: $userPassword)
            
            ButtonPrimary(text: "Iniciar sesión") {
                print("Usuario: \(userEmail)")
            }
            .padding(.horizontal)
            
            Button {
                //TODO: Action Forget password
                print("¿Olvidaste tu contraseña?")
            } label: {
                Text("¿Olvidaste tu contraseña?")
            }

            //TODO: View Line separator
            
            ButtonPrimary(text: "Registrarse") {
                print("Registrarse")
            }
            .padding(.horizontal, 100)

            Text("Loguearse con")
            
            HStack {
                Button {
                    //TODO: Login social network
                } label: {
                    Text("Facebook")
                }
                
                Button {
                    //TODO: Login social network
                } label: {
                    Text("Twitter")
                }
                
                Button {
                    //TODO: Login social network
                } label: {
                    Text("Google")
                }
            }
        }
        .background(LinearGradient(colors: Color.backgroundGradiant,
                                   startPoint: .leading,
                                   endPoint: .trailing))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
