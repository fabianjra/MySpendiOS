//
//  TextFieldReadOnlySelectable.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/24.
//

import SwiftUI

struct TextFieldReadOnlySelectable: View {
    
    var placeHolder: String = ""
    @Binding var text: String
    var iconLeading: Image? = nil
    var colorDisabled: Bool = true
    
    @Binding var errorMessage: String

    var body: some View {
        TextField("", text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           backgroundColor: colorDisabled ? Color.disabledBackground : Color.textFieldBackground,
                                           errorMessage: $errorMessage))
        .disabled(true)
    }
}

#Preview {
    VStack {
        TextFieldReadOnlySelectable(text: .constant("Read only text"),
                                    iconLeading: Image.personFill,
                                    errorMessage: .constant(""))
        
        TextFieldReadOnlySelectable(text: .constant("Read only text without icon"),
                                    errorMessage: .constant(""))
        
        TextFieldReadOnlySelectable(text: .constant("Read only without disabled background"),
                                    colorDisabled: false,
                                    errorMessage: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
