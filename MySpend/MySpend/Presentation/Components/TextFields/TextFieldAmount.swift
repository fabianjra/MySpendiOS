//
//  TextFieldAmount.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/10/24.
//

import SwiftUI

struct TextFieldAmount: View {
    
    var placeHolder: String = "Amount"
    @Binding var text: String
    var iconLeading: Image = Image.dollar
    
    @Binding var errorMessage: String
    
    var body: some View {
        TextField("",text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           isAmount: true,
                                           errorMessage: $errorMessage))
        .keyboardType(.decimalPad)
    }
}

#Preview {
    VStack {
        TextFieldAmount(text: .constant(""),
                       errorMessage: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
