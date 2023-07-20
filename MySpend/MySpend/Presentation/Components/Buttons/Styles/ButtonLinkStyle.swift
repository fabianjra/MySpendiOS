//
//  ButtonLinkStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct ButtonLinkStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //Font family
        .font(.custom(FontFamily.regular.rawValue, size: FontSizes.body))
        .foregroundColor(isEnabled ? Color.buttonLinkForeground : Color.buttonLinkForeground)

        //Button shape
        .frame(maxWidth: .infinity)
    }
}

struct ButtonLinkStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.background
            
            Button("Button Primary") {
                print("button pressed")
            }
            .buttonStyle(ButtonLinkStyle())
            .environment(\.isEnabled, true)
        }
    }
}
