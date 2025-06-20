//
//  ButtonLinkStyle.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/23.
//

import SwiftUI

struct ButtonLinkStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let color: Color
    private let fontFamily: Font.Family
    private let fontsize: Font.Sizes
    
    @Binding private var isLoading: Bool
    
    init(color: Color = Color.buttonForeground,
         fontfamily: Font.Family = .regular,
         fontsize: Font.Sizes = .body,
         isLoading: Binding<Bool> = .constant(false)) {
        self.color = color
        self.fontFamily = fontfamily
        self.fontsize = fontsize
        self._isLoading = isLoading
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(ShowReservesSpace(isLoading == false))
            .font(.montserrat(fontFamily, size: fontsize))
            .foregroundColor(isEnabled ? color : Color.disabledForeground)
            .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            .padding(.vertical)
        
        // MARK: ANIMATIONS
            .overlay(content: {
                if isLoading {
                    Loader()
                        .foregroundColor(Color.textPrimaryForeground)
                        .padding(.vertical, ConstantViews.mediumSpacing)
                }
            })
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
        
        Button("Button loading") {
            print("button pressed")
        }
        .buttonStyle(ButtonLinkStyle(isLoading: .constant(true)))
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
