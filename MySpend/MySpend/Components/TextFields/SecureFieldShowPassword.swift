//
//  SecureFieldShowPassword.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct SecureFieldShowPassword: View {
    
    let placeHolder: String
    @Binding var text: String
    let iconLeading: Image

    var body: some View {
        HStack {
            iconLeading
                .frame(width: 50, height: 50)
                .background(Color.textFieldIconBackground)
            
            SecureField(placeHolder, text:$text)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable) // This avoids suggestions bar on the keyboard.
                
        }
        .background(Color.textfieldBackground)
        .cornerRadius(Radius.textFieldCorners)
    }
}

struct SecureFieldShowPassword_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SecureFieldShowPassword(placeHolder: "Password",
                                                 text: .constant(""),
                                                 iconLeading: Image.lockFill)
        }
        .padding()
        .background(.gray)
    }
}
