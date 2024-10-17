//
//  TextFieldReadOnly.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct TextFieldReadOnly: View {
    
    var placeHolder: String = "Name"
    @Binding var text: String
    var iconLeading: Image? = nil
    var colorDisabled: Bool = true

    var body: some View {
        TextField("", text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           backgroundColor: colorDisabled ? Color.disabledBackground : Color.textFieldBackground))
        .disabled(true)
    }
}

#Preview {
    VStack {
        TextFieldReadOnly(text: .constant("Read only text"),
                          iconLeading: Image.personFill)
        
        TextFieldReadOnly(text: .constant("Read only text without icon"))
        
        TextFieldReadOnly(text: .constant("Read only without disabled background"),
                          colorDisabled: false)
    }
    .padding()
    .background(Color.backgroundBottom)
}
