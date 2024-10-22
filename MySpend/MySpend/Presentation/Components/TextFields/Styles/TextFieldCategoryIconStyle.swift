//
//  TextFieldCategoryIconStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/10/24.
//

import SwiftUI

struct TextFieldCategoryIconStyle: TextFieldStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @Binding private var text: String
    private let iconLeading: Image?
    
    public init(_ text: Binding<String>, iconLeading: Image? = nil) {
        self._text = text
        self.iconLeading = iconLeading
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            
            Text("Icon:")
                .frame(width: ConstantFrames.textFieldHeight,
                       height: ConstantFrames.textFieldHeight)
                .background(Color.textFieldIconBackground)
            
            if let iconLeading = iconLeading {
                
            }
            
            configuration
              //.background(.red) //TODO: For testing
                .frame(height: ConstantFrames.textFieldHeight)
              //.background(.green) //TODO: For testing
                .padding(.horizontal, iconLeading == nil ? nil : .zero)
                .padding(.trailing, iconLeading != nil ? nil : .zero)
                .font(.montserrat(.regular, size: .body))
        }
        .foregroundColor(Color.textFieldForeground)
        
        /// if apply disabled background, all textfield will change to gray when a view is loading.
        //.background(isEnabled ? backgroundColor : Color.disabledBackground)
        .background(Color.textFieldBackground)
        .cornerRadius(.infinity)
    }
}

#Preview {
    @Previewable @State var text = ""
    VStack {
        
        //Nothing:
        TextField("", text: $text)
            .textFieldStyle(TextFieldCategoryIconStyle($text))
        
        //iOS Placeholder
        TextField("iOS placeholder", text: $text)
            .textFieldStyle(TextFieldCategoryIconStyle($text))
            .disabled(true)
        
        //With placeholder and icon, With error
        TextField("", text: $text, prompt:
                    Text("No icon").foregroundColor(.textFieldPlaceholder))
        .textFieldStyle(TextFieldCategoryIconStyle($text, iconLeading: Image.envelopeFill))
        
    }
    .padding()
    .background(Color.backgroundBottom)
}
