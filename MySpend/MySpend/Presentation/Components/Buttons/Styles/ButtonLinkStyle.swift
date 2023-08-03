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
            .font(.montserrat())
            .foregroundColor(isEnabled ? Color.buttonLinkForeground : Color.buttonLinkForeground)
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
