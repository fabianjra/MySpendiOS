//
//  ButtonRounded.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/7/23.
//

import SwiftUI

struct ButtonRounded: View {
    
    let icon: Image = Image.plus
    let color: Color = Color.primaryLeading
    let function: () -> Void
    
    var body: some View {
        Button(action: function, label: {
            icon
                .resizable()
                .frame(width: ConstantFrames.roundedButtonIcon,
                       height: ConstantFrames.roundedButtonIcon)
                .foregroundColor(Color.buttonForeground)
        })
        .padding()
        .background(color)
        .overlay(Circle().stroke(Color.buttonForeground,
                                 lineWidth: ConstantViews.buttonBorderWidth))
        .clipShape(Circle())
        .shadow(color: .shadow.opacity(ConstantColors.opacityHalf),
                radius: ConstantRadius.shadow)
    }
}

#Preview {
    ButtonRounded(function: { })
}
