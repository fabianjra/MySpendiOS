//
//  FormContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/9/24.
//

import SwiftUI

struct FormContainer<Content: View>: View {
    
    private let addPading: Bool
    private let scrollable: Bool
    private let showsIndicators: Bool
    private let backgroundColor: Array<Color>
    private let backgroundCenter: UnitPoint
    
    var content: () -> Content
    
    init(addPading: Bool = true,
         scrollable: Bool = false,
         showsIndicators: Bool = false,
         backgroundColor: Array<Color> = [Color.backgroundFormLight, Color.backgroundFormDark],
         backgroundCenter: UnitPoint = .top,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.scrollable = scrollable
        self.showsIndicators = showsIndicators
        self.addPading = addPading
        self.backgroundColor = backgroundColor
        self.backgroundCenter = backgroundCenter
        self.content = content
    }
    
    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            VStack(content: content)
                .padding(.all, addPading ? nil : .zero)
        }
        .scrollDisabled(!scrollable)
        
        .background(RadialGradient(colors: backgroundColor,
                                   center: backgroundCenter,
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
                          errorMessage: .constant(""))
    }
}
