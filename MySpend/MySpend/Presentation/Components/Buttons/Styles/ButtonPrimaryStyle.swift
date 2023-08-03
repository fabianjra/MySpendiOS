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
    @Binding var isLoading: Bool
    
    init(color: Array<Color> = Color.primaryGradiant,
         isLoading: Binding<Bool> = .constant(false)) {
        self.color = color
        self._isLoading = isLoading
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(Show(isVisible: isLoading == false))
            .font(.montserrat())
            .foregroundColor(isEnabled ? Color.buttonForeground : Color.disabledForeground)
        
        // MARK: SHAPE
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(
                
                //If enabled: Original background color.
                isEnabled ? LinearGradient(colors: color,
                                           startPoint: .leading,
                                           endPoint: .trailing) :
                    
                    //If disabled, but is loading, preserve the original color.
                    isLoading ? LinearGradient(colors: color,
                                               startPoint: .leading,
                                               endPoint: .trailing) :
                    
                    //If disabled and is not loading, show disabled background color.
                    LinearGradient(colors: [Color.disabledBackground],
                                   startPoint: .leading,
                                   endPoint: .trailing)
            )
            .cornerRadius(.infinity)
        
        // MARK: ANIMATIONS
            .overlay(content: {
                if isLoading {
                    Loader()
                        .foregroundColor(Color.textPrimaryForeground)
                        .padding(.vertical, 5)
                }
            })
        
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
            .buttonStyle(ButtonPrimaryStyle(isLoading: .constant(true)))
            //.environment(\.isEnabled, true))
            //.disabled(userEmail.isEmpty || userPassword.isEmpty) //Way to use disabled
            
            
            Button("Button Primary") {
                print("button pressed")
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: .constant(false)))
            
            
            Button("Button disabled") {
                print("button pressed")
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: .constant(false)))
            .disabled(true) //Correct way to disable the button
            //.environment(\.isEnabled, false)
        }
        .padding()
        .background(Color.background)
    }
}
