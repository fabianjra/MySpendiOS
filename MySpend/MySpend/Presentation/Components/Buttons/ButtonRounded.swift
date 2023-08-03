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
                .frame(width: Frames.roundedButtonIcon, height: Frames.roundedButtonIcon)
                .foregroundColor(Color.buttonForeground)
        })
        .padding()
        .background(
            LinearGradient(colors: color,
                           startPoint: .leading,
                           endPoint: .trailing)
            .overlay(Circle().stroke(Color.buttonForeground, lineWidth: Views.buttonBorderWidth))
        )
        .clipShape(Circle())
        .shadow(color: .shadow.opacity(Colors.opacityHalf),
                radius: Radius.shadow)
    }
}

struct ButtonRounded_Previews: PreviewProvider {
    static var previews: some View {
        ButtonRounded(function: { print("hola") })
    }
}
