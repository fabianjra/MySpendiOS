//
//  TextFieldEmail.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldEmail: View {
    
    @Binding var text: String
    @Binding var errorMessage: String
    
    var body: some View {
        TextField("",
                  text: $text,
                  prompt: Text("Email").foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: Image.envelopeFill,
                                           textLimit: ConstantViews.textLimitEmail,
                                           errorMessage: $errorMessage))
        
        .autocapitalization(.none)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
    }
}

#Preview {
    VStack {
        TextFieldEmail(text: .constant(""),
                       errorMessage: .constant(""))
    }
    .padding()
    .background(Color.background)
}
