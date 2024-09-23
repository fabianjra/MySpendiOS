//
//  FormContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/9/24.
//

import SwiftUI

struct FormContainer<Content: View>: View {
    
    let addPading: Bool
    let scrollable: Bool
    let showsIndicators: Bool
    
    var content: () -> Content
    
    init(addPading: Bool = true,
         scrollable: Bool = false,
         showsIndicators: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.scrollable = scrollable
        self.showsIndicators = showsIndicators
        self.addPading = addPading
        self.content = content
    }
    
    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            VStack(content: content)
                .padding(.all, addPading ? nil : .zero)
        }
        .scrollDisabled(!scrollable)
        
        .background(RadialGradient(colors: [Color.backgroundFormLight,
                                            Color.backgroundFormDark],
                                   center: .top,
                                   startRadius: .zero,
                                   endRadius: ConstantColors.endRadiusBackground))
    }
}

#Preview("1 component") {
    FormContainer {
        TextFieldEmail(text: .constant(""),
                       errorMessage: .constant(""))
    }
}

#Preview("2 components") {
    FormContainer {
        TextFieldEmail(text: .constant(""),
                       errorMessage: .constant(""))
        
        TextFieldPassword(text: .constant(""),
                          errorMessage: .constant(""),
                          iconLeading: Image.lockFill)
    }
}
