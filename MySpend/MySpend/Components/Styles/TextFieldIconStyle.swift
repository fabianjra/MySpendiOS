//
//  TextFieldIconLeadingStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import SwiftUI

struct TextFieldIconStyle: TextFieldStyle {
    
    private let placeHolder: String?
    @Binding private var text: String
    private let fontFamily: MontserratFamily
    private let size: FontSizes
    private let iconLeading: Image?
    
    @FocusState var isFocused: Bool
    
    public init(_ placeHolder: String? = nil, text: Binding<String>, fontFamily: MontserratFamily = .regular, size: FontSizes = .body, iconLeading: Image? = nil) {
        self.placeHolder = placeHolder
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
                //.frame(height: Frames.textFieldHeight) //Textfield get full height inside view.
                //.background(.green) //TODO: For testing
                .placeholder(when: text.isEmpty) {
                    Text(placeHolder ?? "")
                        .foregroundColor(Color.textFieldPlaceholder)
                }
                .padding(.horizontal, iconLeading == nil ? nil : .zero)
                .padding(.trailing, iconLeading != nil ? nil : .zero)
                .font(.custom(fontFamily.rawValue, size: size.size))
                //.modifier(frameModifier(active: iconLeading == nil))
                .focused($isFocused)
        }
        .frame(height: Frames.textFieldHeight)
        .foregroundColor(Color.textFieldForeground)
        .background(Color.textfieldBackground)
        .cornerRadius(Radius.textFieldCorners)
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: Radius.textFieldCorners)
                    .stroke(LinearGradient(
                        colors: Color.primaryGradiant,
                        startPoint: .leading,
                        endPoint: .trailing), lineWidth: Shapes.textFieldLineWidth)
            }
        }
    }
    
    //Commented because:
    //This modifier is changing the Height Size when there is no icon.
    struct frameModifier: ViewModifier {
        let active : Bool
        
        @ViewBuilder
        func body(content: Content) -> some View {
            if active {
                content.frame(height: Frames.textFieldHeight)
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
            
            //Nothing:
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle(text: $text))
            
            //iOS Placeholder
            TextField("iOS placeholder", text: $text)
                .textFieldStyle(TextFieldIconStyle(text: $text))
            
            //Only PlaceHolder
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle("Only placeholder",
                                                   text: $text))
            //With placeholder and icon
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle("With placeholder and icon",
                                                   text: $text,
                                                   iconLeading: Image.envelopeFill))
            //Only icon
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle(text: $text,
                                                   iconLeading: Image.envelopeFill))
            
            //Only icon X2
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle(text: $text,
                                                   iconLeading: Image.lockFill))
        }
        .padding()
        .background(.gray)
    }
}
