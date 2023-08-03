//
//  TextFieldPassword.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldPassword: View {
    
    private let placeHolder: String
    @Binding private var text: String
    
    @Binding private var isError: Bool
    @Binding private var errorMessage: String
    private let iconLeading: Image
    
    init(placeHolder: String = "Password",
         text: Binding<String>,
         isError: Binding<Bool>,
         errorMessage: Binding<String>,
         iconLeading: Image) {
        
        self.placeHolder = placeHolder
        self._text = text
        self._isError = isError
        self._errorMessage = errorMessage
        self.iconLeading = iconLeading
    }
    
    var body: some View {
        
        SecureField("", text: $text,
                    prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           textLimit: Views.textLimitPassword,
                                           isError: $isError))
        //.autocapitalization(.none)
        //.textInputAutocapitalization(.never)
        //.autocorrectionDisabled(true)
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
