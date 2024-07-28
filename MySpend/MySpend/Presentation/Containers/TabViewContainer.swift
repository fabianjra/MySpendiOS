//
//  TabViewContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/7/23.
//

import SwiftUI

struct TabViewContainer<Content: View>: View {

    let aligment: Alignment
    var function: () -> Void
    var content: () -> Content
    
    init(aligment: Alignment = .bottom, function: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.aligment = aligment
        self.function = function
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: aligment) {
            ButtonRounded {
                function()
            }
            .padding(.bottom, ConstantViews.paddingButtonRoundedBottomForCurvedTabview)
            
            Color.tabViewBackground
                .clipShape(SemiCircleShapeCurved())
                .frame(height: ConstantFrames.tabViewHeight)
                .cornerRadius(.infinity)
                .shadow(color: .shadow.opacity(ConstantColors.opacityHalf),
                        radius: ConstantRadius.shadow,
                        x: .zero, y: .zero)
                .padding(.horizontal)
                .padding(.bottom)
            
            HStack(content: content)
                .padding(.bottom)
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
