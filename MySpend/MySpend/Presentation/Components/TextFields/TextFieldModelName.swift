//
//  TextFieldCategoryName.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/10/24.
//

import SwiftUI

struct TextFieldModelName: View {
    
    var placeHolder: String = "Name"
    @Binding var text: String
    var iconLeading: Image? = nil
    
    @Binding var errorMessage: String
    
    var body: some View {
        TextField("", text: $text,
                  prompt: Text(placeHolder).foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: iconLeading,
                                           textLimit: ConstantViews.textLimitName,
                                           errorMessage: $errorMessage))
        .keyboardType(.alphabet)
    }
}

#Preview {
    VStack {
        TextFieldModelName(text: .constant(""),
                      errorMessage: .constant(""))
    }
    .padding()
    .background(Color.backgroundBottom)
}
