//
//  TextFieldDecimalIconStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/9/24.
//

import SwiftUI

struct TextFieldDecimalIconStyle: TextFieldStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @Binding private var text: Decimal
    private let family: Font.Family
    private let size: Font.Sizes
    private let iconLeading: Image?
    private let textLimit: Int
    
    private let foregroundColor: Color
    private let backgroundColor: Color
    
    private var showFocusedIndicador: Bool
    private var submitLabel: SubmitLabel
    @FocusState private var isFocused: Bool
    
    public init(_ text: Binding<Decimal>,
                family: Font.Family = .regular,
                size: Font.Sizes = .body,
                iconLeading: Image? = nil,
                textLimit: Int = ConstantViews.textLimitGeneral,
                foregroundColor: Color = Color.textFieldForeground,
                backgroundColor: Color = Color.textfieldBackground,
                showFocusedIndicador: Bool = true,
                submitLabel: SubmitLabel = .done) {
        
        self._text = text
        self.family = family
        self.size = size
        self.iconLeading = iconLeading
        self.textLimit = textLimit
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.showFocusedIndicador = showFocusedIndicador
        self.submitLabel = submitLabel
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if let iconLeading = iconLeading {
                iconLeading
                    .frame(width: ConstantFrames.textFieldHeight,
                           height: ConstantFrames.textFieldHeight)
                    .background(Color.textFieldIconBackground)
            }
            
            configuration
                //.background(.red) //TODO: For testing
                .frame(height: ConstantFrames.textFieldHeight)
                //.background(.green) //TODO: For testing
                .padding(.horizontal, iconLeading == nil ? nil : .zero)
                .padding(.trailing, iconLeading != nil ? nil : .zero)
                .font(.montserrat(family, size: size))
                .submitLabel(submitLabel)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
                .onChange(of: text) {
                    /// Validate the limit character count and allowed characters (numbers and decimal separator).
                    var textString = text.description
                    
                    let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
                    
                    // Filter out any characters that are not numbers or the decimal separator.
                    textString = String(textString.unicodeScalars.filter { allowedCharacters.contains($0) })
                    
                    if textString.count > textLimit {
                        textString = String(textString.prefix(textLimit))
                    }
                    
                    // Convert the filtered and limited string back to a Decimal.
                    if let limitedDecimal = Decimal(string: textString) {
                        text = limitedDecimal
                    }
                }
        }
        .foregroundColor(foregroundColor)
        
        //if apply disabled background, all textfield will change to gray when a view is loading.
        //.background(isEnabled ? backgroundColor : Color.disabledBackground)
        .background(backgroundColor)
        .cornerRadius(.infinity)
        .overlay {
            if showFocusedIndicador {
                if isFocused {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(LinearGradient(
                            colors: Color.primaryGradiant,
                            startPoint: .leading,
                            endPoint: .trailing), lineWidth: ConstantShapes.textFieldLineWidth)
                }
            }
        }
    }
}

#Preview {
    VStack {
        @State var text = ""
        
        //Nothing:
        TextField("", text: $text)
            .textFieldStyle(TextFieldIconStyle($text))
        
        //iOS Placeholder
        TextField("iOS placeholder", text: $text)
            .textFieldStyle(TextFieldIconStyle($text))
            .disabled(true)
        
        //With placeholder and icon, With error
        TextField("", text: $text, prompt:
                    Text("With placeholder and icon").foregroundColor(.textFieldPlaceholder))
        .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill))
        
        //Nothing X2
        TextField("", text: $text)
            .textFieldStyle(TextFieldIconStyle($text))
        
        //Only icon
        TextField("", text: .constant("This textfield is disabled"))
            .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill))
            .disabled(true)
        
        //Only icon X2
        TextField("", text: $text)
            .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.lockFill))
            .padding(.bottom)
        
        VStack {
            SectionContainer(header: "Header for a TextField",
                             isInsideList: false) {
                TextFieldName(text: .constant(""),
                              errorMessage: .constant(""))
            }
        }
    }
    .padding()
    .background(Color.background)
}
