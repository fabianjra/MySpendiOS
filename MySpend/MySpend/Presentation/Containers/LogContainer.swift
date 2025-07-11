//
//  FormScrollContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct LogContainer<Content: View>: View {
    
    private let addPading: Bool
    private let scrollable: Bool
    private let showsIndicators: Bool
    
    private let content: () -> Content
    
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
        .background(LinearGradient(colors: Color.backgroundFormGradiant,
                                   startPoint: .top,
                                   endPoint: .bottom))
    }
}

#Preview {
    LogContainer {
        TextFieldEmail(text: .constant(""),
                       errorMessage: .constant(""))
    }
}
