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

#Preview {
    ZStack {
        Color.backgroundBottom
        
        Button("Button Primary") {
            print("button pressed")
        }
        .buttonStyle(ButtonLinkStyle())
        .environment(\.isEnabled, true)
    }
}
