//
//  TextFieldIconLeadingStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import SwiftUI

struct TextFieldIconStyle: TextFieldStyle {
    
    private let fontFamily: MontserratFamily
    private let size: FontSizes
    private let iconLeading: Image?
    
    public init(_ fontFamily: MontserratFamily = .regular, size: FontSizes = .body, iconLeading: Image? = nil) {
        self.fontFamily = fontFamily
        self.size = size
        self.iconLeading = iconLeading
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        
        HStack {
            if let iconLeading = iconLeading {
                iconLeading
                    .frame(width: Frame.textFieldIcon, height: Frame.textFieldIcon)
                    .background(Color.textFieldIconBackground)
            }
            
            configuration
                .padding(.horizontal, iconLeading == nil ? nil : 0)
                .font(.custom(fontFamily.rawValue, size: size.size))
                .modifier(frameModifier(active: iconLeading == nil))
        }
        .background(Color.textfieldBackground)
        .cornerRadius(Radius.textFieldCorners)
    }
    
    struct frameModifier: ViewModifier {
        let active : Bool
        
        @ViewBuilder
        func body(content: Content) -> some View {
            if active {
                content.frame(height: 50)
            } else {
                content
            }
        }
    }
}

struct TextFieldIconStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var text = ""
        
        VStack {
            TextField("Email", text: $text)
                .textFieldStyle(TextFieldIconStyle(iconLeading: Image.envelopeFill))
        }
        .padding()
        .background(.gray)
    }
}
