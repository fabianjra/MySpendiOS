//
//  TextFieldPasswordIconLeadingTrailing.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct TextFieldPasswordIconLeadingTrailing: View {
    
    let placeHolder: String
    @Binding var text: String
    let icon: Image

    var body: some View {
        HStack {
            icon
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

struct TextFieldPasswordIconLeadingTrailing_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldPasswordIconLeadingTrailing(placeHolder: "Password",
                                                 text: .constant(""),
                                                 icon: Image.lockFill)
        }
        .padding()
        .background(.gray)
    }
}
