//
//  TextFieldIconLeadingStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/23.
//

import SwiftUI

struct TextFieldIconStyle: TextFieldStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @Binding private var text: String
    private let family: Font.Family
    private let size: Font.Sizes
    private let iconLeading: Image?
    
    private let foregroundColor: Color
    private let backgroundColor: Color
    
    @Binding private var isError: Bool
    
    private var showFocusedIndicador: Bool
    @FocusState private var isFocused: Bool
    
    public init(_ text: Binding<String>,
                family: Font.Family = .regular,
                size: Font.Sizes = .body,
                iconLeading: Image? = nil,
                foregroundColor: Color = Color.textFieldForeground,
                backgroundColor: Color = Color.textfieldBackground,
                isError: Binding<Bool> = .constant(false),
                showFocusedIndicador: Bool = true) {
        
        self._text = text
        self.family = family
        self.size = size
        self.iconLeading = iconLeading
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self._isError = isError
        self.showFocusedIndicador = showFocusedIndicador
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
                .font(.montserrat(family, size: size))
                .focused($isFocused)
                .onChange(of: text, perform: { _ in isError = false })
        }
        .foregroundColor(foregroundColor)
        .background(isEnabled ? backgroundColor : Color.disabledBackground)
        .cornerRadius(.infinity)
        .overlay {
            if showFocusedIndicador {
                if isFocused {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(LinearGradient(
                            colors: Color.primaryGradiant,
                            startPoint: .leading,
                            endPoint: .trailing), lineWidth: Shapes.textFieldLineWidth)
                }
            }
            
            if isError {
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(LinearGradient(
                        colors: [Color.warning],
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
                .textFieldStyle(TextFieldIconStyle($text, isError: .constant(false)))
            
            //iOS Placeholder
            TextField("iOS placeholder", text: $text)
                .textFieldStyle(TextFieldIconStyle($text, isError: .constant(false)))
                .disabled(true)
            
            //With placeholder and icon, With error
            TextField("", text: $text, prompt:
                        Text("With placeholder and icon").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill, isError: .constant(true)))
            
            //Nothing X2
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle($text, isError: .constant(false)))
            
            //Only icon
            TextField("", text: .constant("This textfield is disabled"))
                .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill, isError: .constant(false)))
                .disabled(true)
            
            //Only icon X2
            TextField("", text: $text)
                .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.lockFill, isError: .constant(false)))
        }
        .padding()
        .background(Color.background)
    }
}
