//
//  ButtonHorizontalStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 14/8/23.
//

import SwiftUI

struct ButtonHorizontalStyle: ButtonStyle {
    
    var subTitle: String = ""
    var color: Array<Color> = Color.secondaryGradiant
    var iconLeading: Image? = nil

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            
            if let iconLeading = iconLeading {
                iconLeading
                    .foregroundColor(Color.textPrimaryForeground)
                    .padding()
                    .background(
                        LinearGradient(colors: Color.primaryGradiant,
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .clipShape(Circle())
            }
            
            
            VStack(alignment: .leading) {
                configuration.label
                    .font(.montserrat(size: .big))
                    .foregroundColor(Color.buttonForeground)
                    .lineLimit(ConstantViews.singleTextMaxLines)
                
                Text(subTitle)
                    .font(.montserrat(size: .small))
                    .foregroundColor(Color.textFieldPlaceholder)
                    .lineLimit(ConstantViews.singleTextMaxLines)
            }
            .padding(.horizontal)
            
            
            Spacer()
            
            
            Image.arrowRight
                .foregroundColor(Color.textPrimaryForeground)
                .padding()
                .padding(.trailing)
        }
        .padding(.leading)
        
        // MARK: SHAPE
        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
        .padding(.vertical)
        .background(LinearGradient(colors: color,
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(ConstantRadius.corners)
        
        // MARK: EFFECTS
        .scaleEffect(configuration.isPressed ?
                     ConstantAnimations.buttonScalePressed : ConstantAnimations.buttonOriginalPressed)
        .animation(.easeOut(duration: ConstantAnimations.buttonScaleDuration), value: configuration.isPressed)
    }
    
}

#Preview {
    VStack {
        Button("History") {
            print("button pressed")
        }
        .buttonStyle(ButtonHorizontalStyle(subTitle: "Enter the history", iconLeading: Image.stackFill))
        //.disabled(true)
        
        Button("Button without icon") {
            print("button pressed")
        }
        .buttonStyle(ButtonHorizontalStyle(subTitle: "subtitle for button"))
    }
    .padding()
    .background(Color.backgroundBottom)
}
