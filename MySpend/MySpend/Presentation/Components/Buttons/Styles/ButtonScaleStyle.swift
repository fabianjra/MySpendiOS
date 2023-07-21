//
//  ButtonRoundedStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/7/23.
//

import SwiftUI

struct ButtonScaleStyle: ButtonStyle {
    
    let scaleSize: CGFloat = Animations.buttonScalePressed

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ?
                         scaleSize : Animations.buttonOriginalPressed)
            .animation(.easeOut(duration: Animations.buttonScaleDuration),
                       value: configuration.isPressed)
    }
}

struct ButtonScaleStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Scale effect") {
            print("button pressed")
        }
        .buttonStyle(ButtonScaleStyle())
    }
}

