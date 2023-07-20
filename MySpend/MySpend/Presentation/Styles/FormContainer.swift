//
//  FormContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/7/23.
//

import SwiftUI

struct FormContainer<Content: View>: View {
    
    let aligment: Alignment
    let ignoreSafeArea: Bool
    let addPading: Bool
    
    var content: () -> Content
    
    init(aligment: Alignment = .top, ignoreSafeArea: Bool = true, addPading: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.aligment = aligment
        self.ignoreSafeArea = ignoreSafeArea
        self.addPading = addPading
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: aligment) {
            
            Spacer()
                .modifier(IgnoreSafeArea(condition: ignoreSafeArea))
                .background(LinearGradient(colors: Color.backgroundFormGradiant,
                                           startPoint: .leading,
                                           endPoint: .trailing))
            
            VStack(content: content)
                .padding(.all, addPading ? nil : .zero)
        }
    }
}
