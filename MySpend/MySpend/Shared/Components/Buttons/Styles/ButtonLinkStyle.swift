//
//  ButtonLinkStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

//TODO: ELIMINAR cuando se migure AddModifyTransaction
struct ButtonLinkStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let color: Color
    private let fontFamily: Font.Family
    private let fontsize: Font.Sizes
    
    init(color: Color = Color.buttonForeground,
         fontfamily: Font.Family = .regular,
         fontsize: Font.Sizes = .body) {
        self.color = color
        self.fontFamily = fontfamily
        self.fontsize = fontsize
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? color : Color.disabledForeground)
            .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            .padding(.vertical)
    }
}

#Preview {
    VStack {
        Spacer()
        
        Button("Button link") {
            print("button pressed")
        }
        .buttonStyle(ButtonLinkStyle())
        .environment(\.isEnabled, true)
        
        Spacer()
        
        Button("Button disabled") {
            print("button pressed")
        }
        .buttonStyle(ButtonLinkStyle())
        .environment(\.isEnabled, false)
        
        Spacer()
    }
    .background(Color.backgroundBottom)
}
