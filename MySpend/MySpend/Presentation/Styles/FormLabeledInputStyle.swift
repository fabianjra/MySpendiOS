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

#Preview {
    @Previewable @State var text = ""
    
    Form {
        Section(.personalInformationTitle) {
            LabeledContent(.personalInformationInputName) {
                TextField(.personalInformationInputNamePlaceholder, text: $text)
                    .formInputStyle($text)
            }
            .formLabeledInputStyle
        }
    }
    .scrollContentBackground(.hidden)
    .background(.backgroundBottom)
}
