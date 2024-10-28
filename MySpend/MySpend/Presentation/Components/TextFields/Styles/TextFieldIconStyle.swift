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
    private let textLimit: Int
    
    private let foregroundColor: Color
    private let backgroundColor: Color
    
    private var isAmount: Bool = false
    @State private var isError: Bool = false
    @Binding private var errorMessage: String
    
    private var showErrorIndicador: Bool
    private var showFocusedIndicador: Bool
    private var submitLabel: SubmitLabel
    @FocusState private var isFocused: Bool
    
    public init(_ text: Binding<String>,
                family: Font.Family = .regular,
                size: Font.Sizes = .body,
                iconLeading: Image? = nil,
                textLimit: Int = ConstantViews.textLimitGeneral,
                foregroundColor: Color = Color.textFieldForeground,
                backgroundColor: Color = Color.textFieldBackground,
                isAmout: Bool = false,
                errorMessage: Binding<String> = .constant(""),
                showErrorIndicador: Bool = true,
                showFocusedIndicador: Bool = true,
                submitLabel: SubmitLabel = .done) {
        
        self._text = text
        self.family = family
        self.size = size
        self.iconLeading = iconLeading
        self.textLimit = textLimit
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.isAmount = isAmout
        self._errorMessage = errorMessage
        self.showErrorIndicador = showErrorIndicador
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
                .onChange(of: text, {
                    
                    /// Clean error messages on screen. Var taken from Father View.
                    errorMessage = ""
                    isError = false

                    /// Validate the limit character count. Delete extra characters typed.
                    if text.count > textLimit {
                        text = String(text.prefix(textLimit))
                    }
                    
                    if isAmount {
                        let decimalSeparator = UtilsCurrency.getLocalDecimalSeparator()
                        
                        /// Filter to only numbers or decimal:
                        var allowedCharacters = CharacterSet.decimalDigits
                        allowedCharacters.insert(charactersIn: decimalSeparator)
                        
                        var filteredValue = text.unicodeScalars.filter { allowedCharacters.contains($0) }
                        
                        var alreadyDecimalDigited = false
                        
                        /// Recorre el string para validar que solo exista un simbolo decimal:
                        filteredValue = filteredValue.filter {
                            
                            if String($0) == decimalSeparator {
                                if alreadyDecimalDigited {
                                    return false
                                } else {
                                    alreadyDecimalDigited = true
                                    return true
                                }
                            }
                            return true
                        }
                        
                        ///Los UnicodeScalar son representaciones numéricas de los caracteres en el sistema Unicode.
                        ///Cada carácter tiene un "punto de código" (code point) que se usa para codificar ese carácter en una cadena.
                        ///Por ejemplo, el carácter A tiene el punto de código 65, y el carácter é tiene un punto de código más alto.
                        text = String(String.UnicodeScalarView(filteredValue))
                    }
                    
                })
                .onChange(of: errorMessage) {
                    if text.isEmpty && !errorMessage.isEmpty {
                        isError = true
                    } 
                }
        }
        .foregroundColor(foregroundColor)
        
        /// if apply disabled background, all textfield will change to gray when a view is loading.
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
            
            if isError && showErrorIndicador {
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(LinearGradient(
                        colors: [Color.warning],
                        startPoint: .leading,
                        endPoint: .trailing), lineWidth: ConstantShapes.textFieldLineWidth)
            }
        }
        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
        .onTapGesture {
            isFocused = true
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    VStack {
        
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
    .background(Color.backgroundBottom)
}
