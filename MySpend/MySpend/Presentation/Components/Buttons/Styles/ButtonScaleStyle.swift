//
//  ButtonScaleStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/7/23.
//

import SwiftUI

struct ButtonScaleStyle: ButtonStyle {
    
    let scaleSize: CGFloat = ConstantAnimations.buttonScalePressed

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ?
                         scaleSize : ConstantAnimations.buttonOriginalPressed)
            .animation(.easeOut(duration: ConstantAnimations.buttonScaleDuration),
                       value: configuration.isPressed)
    }
}

#Preview {
    Button("Scale effect") {
        print("button pressed")
    }
    .buttonStyle(ButtonScaleStyle())
}
