//
//  FormInputStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/8/26.
//

import SwiftUI

private struct FormLabeledInputStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: ConstantViews.formLabeledContentSpacing) {
            configuration.label
                .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
            
            configuration.content
        }
    }
}

extension View {
    
    /// Establece el limite horizontal entre el label y el textField para introducir valores al texto.
    /// No agrega estilos a la fuente.
    var formLabeledInputStyle: some View {
        self.labeledContentStyle(FormLabeledInputStyle())
    }
}

#Preview(Previews.localeES_ES) {
    @Previewable @State var text = ""
    
    Form {
        Section(.personalInformationTitle) {
            LabeledContent(.inputName) {
                TextField(.personalInformationInputNamePlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
            
            LabeledContent(.inputEmail) {
                TextField(.personalInformationInputEmailPlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
            
            LabeledContent(.inputPhone) {
                TextField(.personalInformationInputPhonePlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
        }
    }
    .scrollContentBackground(.hidden)
    .background(Color.backgroundGradient)
    .environment(\.locale, .init(identifier: Previews.localeES_ES))
}
