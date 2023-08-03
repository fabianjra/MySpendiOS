//
//  TextFieldEmail.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldEmail: View {
    
    @Binding var text: String
    
    @Binding var isError: Bool
    @Binding var errorMessage: String
    
    var body: some View {
        TextField("",
                  text: $text,
                  prompt: Text("Email").foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: Image.envelopeFill,
                                           isError: $isError))
        
        .autocapitalization(.none)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
        .onChange(of: text) { _ in errorMessage = "" }
    }
}

struct TextFieldEmail_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldEmail(text: .constant(""),
                           isError: .constant(false),
                           errorMessage: .constant(""))
        }
        .padding()
        .background(Color.background)
    }
}
