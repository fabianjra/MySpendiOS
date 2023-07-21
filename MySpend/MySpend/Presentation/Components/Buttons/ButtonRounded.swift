//
//  ButtonRounded.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/7/23.
//

import SwiftUI

struct ButtonRounded: View {
    
    let icon: Image = Image.plus
    let color: Array<Color> = Color.primaryGradiant
    let function: () -> Void
    
    var body: some View {
        
        Button(action: function, label: {
            
            icon
                .resizable()
                .frame(width: Frames.roundedButtonIcon, height: Frames.roundedButtonIcon)
                .foregroundColor(Color.buttonForeground)
        })
        .padding()
        .background(
            ZStack{
                LinearGradient(colors: color,
                               startPoint: .leading,
                               endPoint: .trailing)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.buttonForeground, lineWidth: Views.buttonBorderWidth))
            }
        )
        .clipShape(Circle())
        .shadow(color: .shadow.opacity(Colors.opacityHalf),
                radius: Radius.shadow,
                x: .zero, y: .zero)
    }
}

struct ButtonRounded_Previews: PreviewProvider {
    static var previews: some View {
        ButtonRounded(function: { print("hola") })
    }
}
