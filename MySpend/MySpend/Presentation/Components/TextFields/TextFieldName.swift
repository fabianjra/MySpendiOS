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
    
    @Binding private var isError: Bool
    @Binding private var errorMessage: String
    
    init(placeHolder: String = "Name",
         text: Binding<String>,
         iconLeading: Image = Image.personFill,
         isError: Binding<Bool>,
         errorMessage: Binding<String>) {
        
        self.placeHolder = placeHolder
        self._text = text
        self.iconLeading = iconLeading
        self._isError = isError
        self._errorMessage = errorMessage
    }
    
    var body: some View {
        
        TextField("", text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           textLimit: ConstantViews.textLimitName,
                                           isError: $isError))
        
        .onChange(of: text) { errorMessage = "" }
        .textContentType(.name)
        .keyboardType(.alphabet)
    }
}

struct TextFieldName_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldName(text: .constant(""),
                           isError: .constant(false),
                           errorMessage: .constant(""))
        }
        .padding()
        .background(Color.background)
    }
}
