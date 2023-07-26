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
    
    init(text: Binding<String>, iconLeading: Image? = nil) {
        self._text = text
        self.iconLeding = iconLeading
    }
    
    var body: some View {
        TextField("",
                  text: $text,
                  prompt: Text("Name").foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeding,
                                           foregroundColor: Color.disabledForeground,
                                           backgroundColor: Color.disabledBackground,
                                           isError: .constant(false)))
        .disabled(true)
    }
}

struct TextFieldReadOnly_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldReadOnly(text: .constant("Read only text"), iconLeading: Image.personFill)
            
            TextFieldReadOnly(text: .constant("Read only text without icon"))
        }
        .padding()
        .background(Color.background)
    }
}
