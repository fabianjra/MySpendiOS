//
//  FormInputStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/8/26.
//

import SwiftUI

struct FormLabeledInputStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: ConstantViews.formLabeledContentSpacing) {
            configuration.label
                .frame(width: ConstantFrames.formLabelWidth, alignment: .leading)
            
            configuration.content
        }
        .font(.montserrat())
    }
}

extension View {
    var formLabeledInputStyle: some View {
        self.labeledContentStyle(FormLabeledInputStyle())
    }
}

#Preview(Previews.localeES_ES) {
    @Previewable @State var text = ""
    
    Form {
        Section(.personalInformationTitle) {
            LabeledContent(.personalInformationInputName) {
                TextField(.personalInformationInputNamePlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
            
            LabeledContent(.personalInformationInputEmail) {
                TextField(.personalInformationInputEmailPlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
            
            LabeledContent(.personalInformationInputPhone) {
                TextField(.personalInformationInputPhonePlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
        }
    }
    .scrollContentBackground(.hidden)
    .background(.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeES_ES))
}
