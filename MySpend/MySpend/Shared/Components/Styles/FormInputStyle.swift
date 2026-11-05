//
//  FormInputStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/8/26.
//

import SwiftUI

private struct FormInputStyle: TextFieldStyle {
    
    @Binding var text: String
    
    let textLimit: Int
    @FocusState private var isFocused: Bool
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
                .focused($isFocused)
            
                .onChange(of: text) {
                    // Validate the limit character count. Delete extra characters typed.
                    if text.count > textLimit {
                        text = String(text.prefix(textLimit))
                    }
                }
            
            if isFocused && !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image.xmarkCircleFIll
                        .foregroundStyle(Color.secondary)
                }
                .buttonStyle(.plain)
                //.accessibilityLabel("Clear text")
            }
        }
    }
}

extension View {
    
    /// Permite establecer el boton de borrado de texto con una equis.
    /// Tambien establece el limite de caracteres maximos.
    /// No establece ningun efecto ni estilo a la fuente.
    func formInputStyle(_ text: Binding<String>, textLimit: Int = ConstantViews.textLimitGeneral) -> some View {
        self.textFieldStyle(FormInputStyle(text: text, textLimit: textLimit))
    }
}

#Preview {
    @Previewable @State var text = ""
    
    Form {
        LabeledContent(.inputName) {
            TextField(.personalInformationInputNamePlaceholder, text: $text)
                .formInputStyle($text)
        }
    }
}
