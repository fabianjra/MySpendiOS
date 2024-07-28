//
//  ButtonPrimaryStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct ButtonPrimaryStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let color: Array<Color>
    @Binding private var isLoading: Bool
    private let neverBgDisabled: Bool
    
    init(color: Array<Color> = Color.primaryGradiant,
         isLoading: Binding<Bool> = .constant(false),
         neverBgDisabled: Bool = false) {
        
        self.color = color
        self._isLoading = isLoading
        self.neverBgDisabled = neverBgDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(Show(isVisible: isLoading == false))
            .font(.montserrat())
            .foregroundColor(
                
                //If enabled: Original foreground color.
                isEnabled ? Color.buttonForeground :
                    
                    //If disabled and dont want to show foreground disabled, preserve the original color.
                neverBgDisabled ? Color.buttonForeground :
                    
                    //If disabled and want to show foregroundDisabled: show disabled foreground color.
                Color.disabledForeground)
        
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
                    
                    //If disabled and is not loading but dont want to show BackGround disabled, preserve the original color.
                neverBgDisabled ? LinearGradient(colors: color,
                                                 startPoint: .leading,
                                                 endPoint: .trailing) :
                    
                    //If disabled and is not loading and want to show BackGroundDisabled: show disabled background color.
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
        
        // MARK: EFFECTS
            .scaleEffect(configuration.isPressed ?
                         ConstantAnimations.buttonScalePressed : ConstantAnimations.buttonOriginalPressed)
            .animation(.easeOut(duration: ConstantAnimations.buttonScaleDuration), value: configuration.isPressed)
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
