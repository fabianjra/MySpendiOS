//
//  Prueba.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

//TODO: Remover este archivo. es solamente de ejmplo para pruebas.
//Funcion: No mover la vista cuando se selecciona un campo de texto.

import SwiftUI

struct PruebaNoMoverView: View {
    @State private var text: String = ""

    var body: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    Text("Inicio de sesión")
                        .font(.title)

                    TextField("Usuario", text: $text)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    SecureField("Contraseña", text: $text)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .onAppear {
                    // Scroll hasta el campo de texto cuando aparece la vista
                    scrollViewProxy.scrollTo(0, anchor: .top)
                }
                .onChange(of: text) { _ in
                    // Scroll hasta el campo de texto cuando se edita
                    scrollViewProxy.scrollTo(0, anchor: .top)
                }
            }
        }
    }
}

struct PruebaNoMoverView_Previews: PreviewProvider {
    static var previews: some View {
        PruebaNoMoverView()
    }
}

