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
                .background(RadialGradient(colors: [Color.backgroundTop,
                                            Color.background],
                                           center: .top,
                                           startRadius: .zero,
                                           endRadius: Colors.endRadiusBackground))
            
            VStack(content: content)
                .padding(.all, addPading ? nil : .zero)
        }
    }
}

struct ContentContainer_Previews: PreviewProvider {
    static var previews: some View {
        ContentContainer {
            HeaderNavigator(subTitle: "Inside of container")
        }
    }
}
