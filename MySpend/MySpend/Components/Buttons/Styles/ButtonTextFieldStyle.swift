//
//  ButtonTextFieldStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/10/24.
//

import SwiftUI

struct ButtonTextFieldStyle: ButtonStyle {
    
    var icon: String = ""
    var actionClear: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            TextPlain("Icon:",
                      color: Color.textFieldForeground)
            
            if !icon.isEmpty {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: FrameSize.width.iconInsideTextField,
                           height: FrameSize.height.iconInsideTextField)
                    .foregroundColor(Color.textFieldForeground)
            } else {
                TextPlain("No selected",
                          color: Color.textFieldPlaceholder)
            }
            
            Spacer()
            
            if !icon.isEmpty {
                Image.xmarkCircleFIll
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: FrameSize.width.iconInsideTextField,
                           height: FrameSize.height.iconInsideTextField)
                    .foregroundColor(Color.textFieldPlaceholder)
                    .padding(.trailing)
                    .onTapGesture {
                        actionClear()
                    }
            }
        }
        .padding(.leading)
        
        // MARK: SHAPE
        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
        .frame(height: ConstantFrames.textFieldHeight)
        .background(Color.textFieldBackground)
        .cornerRadius(.infinity)
        
        // MARK: EFFECTS
        .scaleEffect(configuration.isPressed ?
                     ConstantAnimations.buttonScalePressed : ConstantAnimations.buttonOriginalPressed)
        .animation(.easeOut(duration: ConstantAnimations.buttonScaleDuration), value: configuration.isPressed)
    }
    
}

#Preview {
    VStack {
        Button("Icon:") {
            print("button pressed")
        }
        .buttonStyle(ButtonTextFieldStyle(icon: "envelope.fill") {})
        //.disabled(true)
        
        Button("No icon") {
            print("button pressed")
        }
        .buttonStyle(ButtonTextFieldStyle() {})
    }
    .padding()
    .background(Color.backgroundBottom)
}
