//
//  TextFieldPassword.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldPassword: View {
    
    @Binding var text: String
    
    @Binding var isError: Bool
    @Binding var errorMessage: String
    let iconLeading: Image
    
    var body: some View {
        
        SecureField("",
                    text: $text,
                    prompt: Text("Password").foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           isError: $isError))
        
        .autocapitalization(.none)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        //.keyboardType(.asciiCapable) //This avoids suggestions bar on the keyboard.
        .onChange(of: text) { _ in errorMessage = "" }
    }
}

struct TextFieldPassword_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldPassword(text: .constant(""),
                              isError: .constant(false),
                              errorMessage: .constant(""),
                              iconLeading: Image.lockFill)
        }
        .padding()
        .background(Color.background)
    }
}
