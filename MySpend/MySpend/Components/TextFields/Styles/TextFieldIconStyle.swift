//
//  TextFieldIconLeadingStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import SwiftUI

struct TextFieldIconStyle: TextFieldStyle {
    
    @Binding private var text: String
    private let fontFamily: FontFamily
    private let size: CGFloat
    private let iconLeading: Image?
    
    @FocusState var isFocused: Bool
    
    public init(_ text: Binding<String>, fontFamily: FontFamily = .regular, size: CGFloat = FontSizes.body, iconLeading: Image? = nil) {
        self._text = text
        self.fontFamily = fontFamily
        self.size = size
        self.iconLeading = iconLeading
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        
        HStack {
            if let iconLeading = iconLeading {
                iconLeading
                    .frame(width: Frames.textFieldHeight, height: Frames.textFieldHeight)
                    .background(Color.textFieldIconBackground)
            }
            
            configuration
                .frame(height: Frames.textFieldHeight)
                //.background(.green) //TODO: For testing
                .padding(.horizontal, iconLeading == nil ? nil : .zero)
                .padding(.trailing, iconLeading != nil ? nil : .zero)
                .font(.custom(fontFamily.rawValue, size: size))
                .focused($isFocused)
        }
        .foregroundColor(Color.textFieldForeground)
        .background(Color.textfieldBackground)
        .cornerRadius(Radius.corners)
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: Radius.corners)
                    .stroke(LinearGradient(
                        colors: Color.primaryGradiant,
                        startPoint: .leading,
                        endPoint: .trailing), lineWidth: Shapes.textFieldLineWidth)
            }
        }
    }
}

struct TextFieldIconStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var text = ""
        
        VStack {
            
            //Nothing:
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle($text))
            
            //iOS Placeholder
            TextField("iOS placeholder", text: $text)
                .textFieldStyle(TextFieldIconStyle($text))
            
            //With placeholder and icon
            TextField("", text: $text, prompt:
                        Text("With placeholder and icon").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill))
            
            //Nothing X2
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle($text))
            
            //Only icon
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill))
            
            //Only icon X2
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.lockFill))
        }
        .padding()
        .background(.gray)
    }
}
