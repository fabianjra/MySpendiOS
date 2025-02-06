//
//  TextFieldPassword.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldPassword: View {
    
    var placeHolder: String = "Password"
    @Binding var text: String
    var iconLeading: Image = Image.lockFill
    
    @Binding var errorMessage: String

    var body: some View {
        SecureField("", text: $text,
                    prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           textLimit: ConstantViews.textLimitPassword,
                                           errorMessage: $errorMessage))
        .textContentType(.password)
        //.autocapitalization(.none)
        //.textInputAutocapitalization(.never)
        //.autocorrectionDisabled(true)
        //.keyboardType(.asciiCapable) //This avoids suggestions bar on the keyboard.
    }
}

#Preview {
    VStack {
        TextFieldPassword(text: .constant(""),
                          iconLeading: Image.lockFill,
                          errorMessage: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
