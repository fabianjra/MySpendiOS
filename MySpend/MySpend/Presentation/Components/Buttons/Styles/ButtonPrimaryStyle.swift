//
//  ButtonPrimaryStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct ButtonPrimaryStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //Font family
            .font(Font.custom(FontFamily.regular.rawValue, size: FontSizes.body))
            .foregroundColor(isEnabled ? Color.buttonForeground : Color.buttonForegroundDisabled)

            //Button shape
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(isEnabled ? LinearGradient(colors: Color.primaryGradiant,
                                                   startPoint: .leading,
                                                   endPoint: .trailing) :
                            LinearGradient(colors: [Color.buttonBackgroundDisabled],
                                           startPoint: .leading,
                                           endPoint: .trailing)
            )
            .cornerRadius(Radius.buttonCorners)
        
            //Button animations
            .scaleEffect(configuration.isPressed ?
                         Animations.buttonScalePressed : Animations.buttonOriginalPressed)
            .animation(.easeOut(duration: Animations.buttonScaleDuration), value: configuration.isPressed)
    }
}

struct ButtonPrimaryStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        Button("Button Primary") {
            print("button pressed")
        }
        .buttonStyle(ButtonPrimaryStyle())
        .environment(\.isEnabled, true)
        //.disabled(userEmail.isEmpty || userPassword.isEmpty) //Way to use disabled
    }
}