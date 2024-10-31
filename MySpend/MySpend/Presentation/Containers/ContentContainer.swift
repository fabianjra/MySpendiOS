//
//  ContentContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct ContentContainer<Content: View>: View {
    
    let aligment: Alignment
    let ignoreSafeArea: Bool
    let addPading: Bool
    let addBackground: Bool
    
    var content: () -> Content
    
    init(aligment: Alignment = .top, 
         ignoreSafeArea: Bool = true,
         addPading: Bool = true,
         addBackground: Bool = true,
         @ViewBuilder content: @escaping () -> Content) {
        self.aligment = aligment
        self.ignoreSafeArea = ignoreSafeArea
        self.addPading = addPading
        self.addBackground = addBackground
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: aligment) {
            
            Spacer()
                .modifier(IgnoreSafeArea(condition: ignoreSafeArea))
                .modifier(addRadialGradientBackGround(condition: addBackground,
                                                      color: Color.backgroundContentGradient))
            
            VStack(content: content)
                .padding(.all, addPading ? nil : .zero)
        }
        .ignoresSafeArea(.keyboard) // Dont allow the view go up when show keybowrd in a modal.
    }
}

#Preview("Using background") {
    ContentContainer {
        HeaderNavigator(subTitle: "Inside of container")
    }
}

#Preview("Without background") {
    ContentContainer(addBackground: false) {
        HeaderNavigator(subTitle: "Inside of container",
                        textColor: Color.textFieldForeground)
    }
}
