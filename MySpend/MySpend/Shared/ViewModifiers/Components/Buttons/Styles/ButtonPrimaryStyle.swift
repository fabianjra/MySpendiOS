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
            .modifier(ShowReservesSpace(isLoading == false))
            .font(.montserrat())
            .foregroundColor(
                //If enabled: Original foreground color.
                //If disabled and dont want to show foreground disabled, preserve the original color.
                isEnabled || neverBgDisabled ? Color.buttonForeground :

                    //If disabled and want to show foregroundDisabled: show disabled foreground color.
                Color.disabledForeground)
        
        // MARK: SHAPE
            .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            .padding(.vertical)
            .background(
                //If enabled: Original background color.
                //If disabled, but is loading, preserve the original color.
                //If disabled and is not loading but dont want to show BackGround disabled, preserve the original color.
                isEnabled || isLoading || neverBgDisabled ?
                
                backgroundButton(color) :
                    
                    //If disabled and is not loading and want to show BackGroundDisabled: show disabled background color.
                backgroundButton([Color.disabledBackground])
            )
            .cornerRadius(.infinity)
        
        // MARK: ANIMATIONS
            .overlay(content: {
                if isLoading {
                    Loader()
                        .foregroundColor(Color.textPrimaryForeground)
                        .padding(.vertical, ConstantViews.mediumSpacing)
                }
            })
        
        // MARK: EFFECTS
            .scaleEffect(configuration.isPressed ?
                         ConstantAnimations.buttonScalePressed : ConstantAnimations.buttonOriginalPressed)
            .animation(.easeOut(duration: ConstantAnimations.buttonScaleDuration), value: configuration.isPressed)
    }
    
    private func backgroundButton(_ color: [Color]) -> some View {
        LinearGradient(colors: color,
                       startPoint: .leading,
                       endPoint: .trailing)
    }
}

#Preview {
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
    .background(Color.backgroundBottom)
}
