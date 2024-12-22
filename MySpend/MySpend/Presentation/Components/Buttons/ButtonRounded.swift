//
//  ButtonRounded.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/7/23.
//

import SwiftUI

struct ButtonRounded: View {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    let icon: Image = Image.plus
    let color: Color = Color.primaryLeading
    let action: () -> Void
    
    var body: some View {
        VStack {
            icon
                .resizable()
                .frame(width: ConstantFrames.roundedButtonIcon,
                       height: ConstantFrames.roundedButtonIcon)
                .foregroundColor(Color.buttonForeground)
        }
        .padding()
        .background(isEnabled ? color : Color.disabledBackground)
        .overlay(Circle().stroke(Color.buttonForeground,
                                 lineWidth: ConstantViews.buttonBorderWidth))
        .clipShape(Circle())
        .shadow(color: .shadow.opacity(ConstantColors.opacityHalf),
                radius: ConstantRadius.shadow)
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    ButtonRounded(action: { })
    
    ButtonRounded(action: { })
        .disabled(true)
}
