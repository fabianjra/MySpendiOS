//
//  TextFieldName.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldName: View {
    
    private let placeHolder: String
    @Binding private var text: String
    private let iconLeading: Image
    
    @Binding private var errorMessage: String
    
    init(placeHolder: String = "Name",
         text: Binding<String>,
         iconLeading: Image = Image.personFill,
         errorMessage: Binding<String>) {
        
        self.placeHolder = placeHolder
        self._text = text
        self.iconLeading = iconLeading
        self._errorMessage = errorMessage
    }
    
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
    .background(Color.background)
}
