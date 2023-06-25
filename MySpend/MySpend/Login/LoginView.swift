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

            TextField("Correo electronico", text:$userEmail)
            
            TextField("Contraseña", text: $userPassword)
            
            Button {
                //TODO: Action Login
            } label: {
                Text("Iniciar sesión")
            }
            
            Button {
                //TODO: Action Forget password
            } label: {
                Text("¿Olvidaste tu contraseña?")
            }

            //TODO: View Line separator
            
            Button {
                //TODO: Action Register
            } label: {
                Text("Registrarse")
            }

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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
