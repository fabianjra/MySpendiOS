//
//  TextFieldIconLeading.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/23.
//

import SwiftUI

struct TextFieldIconLeading: View {
    
    @State private var text: String
    let placeHolder: String
    var icon: Image
    
    init(placeHolder: String, text: String, icon: Image) {
        self.placeHolder = placeHolder
        self.text = text
        self.icon = icon
    }
    
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
        
        @State var text = ""
        
        VStack {
            TextFieldIconLeading(placeHolder: "Correo electronico",
                             text: text,
                             icon: Image.userFill)
        }
        .padding()
        .background(.gray)
    }
}
