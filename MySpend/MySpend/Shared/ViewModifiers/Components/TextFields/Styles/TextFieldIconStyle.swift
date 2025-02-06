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
    
    private var isAmount: Bool
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
                isAmount: Bool = false,
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
        self.isAmount = isAmount
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
            //.background(.red) //For testing
                .frame(height: ConstantFrames.textFieldHeight)
            //.background(.green) //For testing
                .padding(.horizontal, iconLeading == nil ? nil : .zero)
                .padding(.trailing, iconLeading != nil ? nil : .zero)
                .font(.montserrat(family, size: size))
                .submitLabel(submitLabel)
                .focused($isFocused)
                .onChange(of: text, {
                    
                    /// Clean error messages on screen. Var taken from Father View.
                    errorMessage = ""
                    isError = false
                    
                    if isAmount {
                        text = onChangeAmount()
                    } else {
                        /// Validate the limit character count. Delete extra characters typed.
                        if text.count > textLimit {
                            text = String(text.prefix(textLimit))
                        }
                    }
                })
                .onChange(of: errorMessage) {
                    if text.isEmpty && !errorMessage.isEmpty {
                        isError = true
                    }
                }
                .onChange(of: isFocused) {
                    if isAmount {
                        onChangeFocusAmount(isFocused)
                    }
                }
            
            if isFocused && !text.isEmpty {
                Image.xmarkCircleFIll
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: FrameSize.width.iconInsideTextField,
                           height: FrameSize.height.iconInsideTextField)
                    .foregroundColor(Color.textFieldPlaceholder)
                    .padding(.trailing)
                    .onTapGesture {
                        DispatchQueue.main.async { // Allows to clean the text even if its selected by autocorrect.
                            text = ""
                        }
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
                        colors: [Color.alert],
                        startPoint: .leading,
                        endPoint: .trailing), lineWidth: ConstantShapes.textFieldLineWidth)
            }
        }
        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
        .onTapGesture {
            isFocused = true
        }
    }
    
    private func onChangeAmount() -> String {
        let decimalSeparator = CurrencyManager.getLocalDecimalSeparator
        let groupingSeparator = CurrencyManager.getLocalGroupingSeparator
        
        /// Filter to only numbers or decimal:
        var allowedCharacters = CharacterSet.decimalDigits
        allowedCharacters.insert(charactersIn: decimalSeparator + groupingSeparator)
        
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
        ///Convierte el texto filtrado a una cadena temporal para la validación del límite:
        var tempText = String(String.UnicodeScalarView(filteredValue))
        
        /// Verificar si contiene un separador decimal:
        if tempText.contains(decimalSeparator) {
            
            /// Permitir hasta 15 caracteres si hay un separador decimal:
            if tempText.count > CurrencyManager.amoutMaxLengthWithDecimal {
                tempText = String(tempText.prefix(CurrencyManager.amoutMaxLengthWithDecimal))
            }
            
        } else {
            /// Si no tiene separador decimal y alcanza 12 caracteres, permitir agregarlo:
            if tempText.count == CurrencyManager.amoutMaxLength && text.last == Character(decimalSeparator) {
                tempText.append(decimalSeparator)
                
            } else if tempText.count > CurrencyManager.amoutMaxLength {
                tempText = String(tempText.prefix(CurrencyManager.amoutMaxLength))
            }
        }
        
        return tempText
    }
    
    private func onChangeFocusAmount(_ isFocused: Bool) {
        let formatter = UtilsCurrency.getLocalFormatter
        
        if isFocused {
            
            if let number = formatter.number(from: text) {
                let decimalValue = number.decimalValue
                
                if decimalValue == .zero {
                    // Si el valor es 0, limpiar
                    text = ""
                } else {
                    let decimalSeparator = CurrencyManager.getLocalDecimalSeparator
                    let groupingSeparator = CurrencyManager.getLocalGroupingSeparator
                    
                    let decimalParts = formatter.string(from: number)!.split(separator: decimalSeparator)
                    
                    if decimalParts.count > 1, decimalParts.last!.allSatisfy({ $0 == "0" || $0 == decimalSeparator.first }) {
                        text = String(decimalParts.first!).replacingOccurrences(of: groupingSeparator, with: "")
                    } else {
                        // Mantener el número sin formato pero con los decimales significativos
                        text = formatter.string(from: number)!.description.replacingOccurrences(of: groupingSeparator, with: "")
                    }
                }
            } else {
                text = ""
            }
            
        } else {
            if let numberFromCast = formatter.number(from: text) {
                
                let decimalValue = numberFromCast.decimalValue
                
                if decimalValue == .zero {
                    text = ""
                } else {
                    text = formatter.string(from: numberFromCast) ?? ""
                }
            } else {
                text = ""
            }
        }
    }
}

#Preview {
    @Previewable @State var text = "asdfsfasdf asdf asf s asdf saf sf saf sa4w5345345354345"
    @Previewable @State var amount = ""
    
    VStack {
        //Nothing:
        TextField("", text: $text)
            .textFieldStyle(TextFieldIconStyle($text))
        
        //Only icon
        TextField("", text: .constant("This textfield is disabled"))
            .textFieldStyle(TextFieldIconStyle($text, iconLeading: Image.envelopeFill))
            .disabled(true)
        
        VStack {
            SectionContainer("Header for a TextField",
                             isInsideList: false) {
                TextFieldName(text: .constant(""),
                              errorMessage: .constant(""))
            }
        }
    }
    .padding()
    .background(Color.backgroundBottom)
    
    VStack {
        TextField("", text: $amount,
                  prompt: Text("Enter amount").foregroundColor(.textFieldPlaceholder))
        .textFieldStyle(TextFieldIconStyle($amount, iconLeading: Image.envelopeFill, isAmount: true))
        
    }
    .padding()
    .background(Color.backgroundBottom)
}
