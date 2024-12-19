//
//  TextFieldNotes.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/10/24.
//

import SwiftUI

struct TextFieldNotes: View {
    
    var placeHolder: String = "Notes"
    @Binding var text: String
    
    var body: some View {
        TextField("",text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder), axis: .vertical)
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           textLimit: ConstantViews.textMaxLength,
                                           showErrorIndicador: false))
        .keyboardType(.alphabet)
    }
}

#Preview {
    VStack {
        TextFieldNotes(text: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
