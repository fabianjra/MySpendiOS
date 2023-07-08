//
//  ButtonPrimaryStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct ButtonPrimaryStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom(FontFamily.regular.rawValue,
                              size: FontSizes.body))
            .foregroundColor(Color.buttonForeground)

            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(LinearGradient(colors: Color.primaryGradiant,
                                       startPoint: .leading,
                                       endPoint: .trailing))
            .cornerRadius(Radius.buttonCorners)
        
            .scaleEffect(configuration.isPressed ? 1.05 : 1 )
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ButtonPrimaryStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        Button("Button Primary") {
            print("button pressed")
        }
        .buttonStyle(ButtonPrimaryStyle())
    }
}
