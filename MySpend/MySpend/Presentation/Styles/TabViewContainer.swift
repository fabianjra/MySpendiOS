//
//  TabViewContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/7/23.
//

import SwiftUI

struct TabViewContainer<Content: View>: View {

    var function: () -> Void
    var content: () -> Content
    
    init(function: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.function = function
        self.content = content
    }
    
    var body: some View {
        ZStack{
            
            ButtonRounded {
                function()
            }
            .padding(.bottom, Views.paddingButtonRoundedBottom)
            
            Color.tabViewBackground
                .clipShape(SemiCircleShape())
                .frame(height: Frames.tabViewHeight)
                .cornerRadius(.infinity)
                .shadow(color: .shadow.opacity(Colors.opacityHalf),
                        radius: Radius.shadow,
                        x: .zero, y: .zero)
                .padding(.horizontal)
                .padding(.bottom)
            
            HStack(content: content)
        }
    }
}

struct TabViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabViewContainer {
            print("Button add pressed")
        } content: {
            
        }

    }
}
