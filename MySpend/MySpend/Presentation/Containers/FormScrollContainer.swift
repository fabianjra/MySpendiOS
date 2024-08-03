//
//  FormScrollContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct FormScrollContainer<Content: View>: View {
    
    let addPading: Bool
    let scrollDisabled: Bool
    let showsIndicators: Bool
    
    var content: () -> Content
    
    init(addPading: Bool = true, scrollDisabled: Bool = true, showsIndicators: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.scrollDisabled = scrollDisabled
        self.showsIndicators = showsIndicators
        self.addPading = addPading
        self.content = content
    }
    
    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            VStack(content: content)
                .padding(.all, addPading ? nil : .zero)
        }
        .scrollDisabled(scrollDisabled)
        .background(LinearGradient(colors: Color.backgroundFormGradiant,
                                   startPoint: .leading,
                                   endPoint: .trailing))
    }
}

struct FormScrollContainer_Previews: PreviewProvider {
    static var previews: some View {
        FormScrollContainer {
            TextFieldEmail(text: .constant(""),
                           errorMessage: .constant(""))
        }
    }
}
