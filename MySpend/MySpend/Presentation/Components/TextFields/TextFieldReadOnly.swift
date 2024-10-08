//
//  TextFieldReadOnly.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct TextFieldReadOnly: View {
    
    @Binding private var text: String
    private let iconLeding: Image?
    private let colorDisabled: Bool
    
    init(text: Binding<String>, iconLeading: Image? = nil, colorDisabled: Bool = true) {
        self._text = text
        self.iconLeding = iconLeading
        self.colorDisabled = colorDisabled
    }
    
    var body: some View {
        TextField("", text: $text,
                  prompt: Text("Name").foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeding,
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
