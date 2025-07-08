//
//  TextFieldName.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldName: View {
    
    var placeHolder: String = "Name"
    @Binding var text: String
    var iconLeading: Image? = Image.personFill
    
    @Binding var errorMessage: String
    
    var body: some View {
        TextField("", text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           textLimit: ConstantViews.textLimitName,
                                           errorMessage: $errorMessage))
        .textContentType(.name)
        .keyboardType(.alphabet)
    }
}

#Preview {
    VStack {
        TextFieldName(text: .constant(""),
                      errorMessage: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
