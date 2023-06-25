//
//  TextFieldIconLeading.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct TextFieldIconLeading: View {
    
    let placeHolder: String
    @Binding var text: String
    let icon: Image
    
    var body: some View {
        HStack {
            icon
                .padding()
                .background(Color.textFieldIconBackground)
            
            TextField(placeHolder, text:$text)
                .font(Fonts.primaryTextfield)
        }
        .background(Color.textfieldBackground)
        .cornerRadius(Radius.textField)
    }
}

struct TextFieldIconLeading_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            TextFieldIconLeading(placeHolder: "Email",
                                 text: .constant(""),
                                 icon: Image.envelopeFill)
        }
        .padding()
        .background(.gray)
    }
}
