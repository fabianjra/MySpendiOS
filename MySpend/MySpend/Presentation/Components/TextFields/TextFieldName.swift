//
//  TextFieldName.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 17/7/23.
//

import SwiftUI

struct TextFieldName: View {
    
    @Binding var text: String
    
    @Binding var isError: Bool
    @Binding var errorMessage: String
    
    var body: some View {
        
        TextField("",
                  text: $text,
                  prompt: Text("Name").foregroundColor(.textFieldPlaceholder))
        
        .textFieldStyle(TextFieldIconStyle($text,
                                           iconLeading: Image.personFill,
                                           isError: $isError))
        
        .onChange(of: text) { _ in errorMessage = "" }
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
