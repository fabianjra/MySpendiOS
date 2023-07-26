//
//  ButtonPrimaryStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct ButtonPrimaryStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    let color: Array<Color>
    
    init(color: Array<Color> = Color.primaryGradiant) {
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.montserrat())
            .foregroundColor(isEnabled ? Color.buttonForeground : Color.disabledForeground)

            //MARK: SHAPE
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(isEnabled ? LinearGradient(colors: color,
                                                   startPoint: .leading,
                                                   endPoint: .trailing) :
                            LinearGradient(colors: [Color.disabledBackground],
                                           startPoint: .leading,
                                           endPoint: .trailing)
            )
            .cornerRadius(.infinity)
        
            //MARK: ANIMATIONS
            .scaleEffect(configuration.isPressed ?
                         Animations.buttonScalePressed : Animations.buttonOriginalPressed)
            .animation(.easeOut(duration: Animations.buttonScaleDuration), value: configuration.isPressed)
    }
}

struct ButtonPrimaryStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Button Primary") {
                print("button pressed")
            }
            .buttonStyle(ButtonPrimaryStyle())
            .environment(\.isEnabled, true)
            //.disabled(userEmail.isEmpty || userPassword.isEmpty) //Way to use disabled
            
            Button("Button disabled") {
                print("button pressed")
            }
            .buttonStyle(ButtonPrimaryStyle())
            .environment(\.isEnabled, false)
        }
        .padding()
        .background(Color.background)
    }
}
