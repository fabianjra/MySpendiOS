//
//  ButtonNavigationBack.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/23.
//

import SwiftUI

struct ButtonNavigationBack: View {
    
    let color: Color
    let function: () -> Void
    
    var body: some View {
        Button {
            function()
        } label: {
            Image.chevronLeft
                .resizable()
                .frame(width: FrameSize.width.buttonBack, height: FrameSize.height.buttonBack)
                .foregroundColor(color)
                .fontWeight(.ultraLight)
        }
    }
}

#Preview {
    VStack {
        ButtonNavigationBack(color: Color.textPrimaryForeground) { print("pressed") }
        
        ButtonNavigationBack(color: Color.red) { print("pressed") }
        //.padding(.leading, -((saveSize.width / 2) - 20)) //If need to use ZStack.
    }
    .padding()
    .background(Color.backgroundBottom)
}
