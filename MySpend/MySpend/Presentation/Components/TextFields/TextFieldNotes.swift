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
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           textLimit: ConstantViews.textMaxLength,
                                           showErrorIndicador: false))
    }
}

#Preview {
    VStack {
        TextFieldNotes(text: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
