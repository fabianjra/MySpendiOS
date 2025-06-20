//
//  TextFieldEmail.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldEmail: View {
    
    var placeHolder: String = "Email"
    @Binding var text: String
    var iconLeading: Image = Image.envelopeFill
    
    @Binding var errorMessage: String
    
    var body: some View {
        TextField("",text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
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
    .background(Color.backgroundBottom)
}
