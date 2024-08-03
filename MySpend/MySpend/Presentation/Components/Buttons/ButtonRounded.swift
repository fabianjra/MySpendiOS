//
//  ButtonRounded.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/7/23.
//

import SwiftUI

struct ButtonRounded: View {
    
    private let icon: Image
    private let color: Array<Color>
    private let function: () -> Void
    
    init(icon: Image = Image.plus,
         color: Array<Color> = Color.primaryGradiant,
         function: @escaping () -> Void) {
        
        self.icon = icon
        self.color = color
        self.function = function
    }
    
    var body: some View {
        Button(action: function, label: {
            icon
                .resizable()
                .frame(width: ConstantFrames.roundedButtonIcon, height: ConstantFrames.roundedButtonIcon)
                .foregroundColor(Color.buttonForeground)
        })
        .padding()
        .background(
            LinearGradient(colors: color,
                           startPoint: .leading,
                           endPoint: .trailing)
            .overlay(Circle().stroke(Color.buttonForeground, lineWidth: ConstantViews.buttonBorderWidth))
        )
        .clipShape(Circle())
        .shadow(color: .shadow.opacity(ConstantColors.opacityHalf),
                radius: ConstantRadius.shadow)
    }
}

#Preview {
    ButtonRounded(function: { print("hola") })
}
