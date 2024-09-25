//
//  ButtonNavigationBack.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/23.
//

import SwiftUI

struct ButtonNavigation: View {
    
    var image: Image = Image.chevronLeft
    var tintColor: Color = Color.textPrimaryForeground
    let function: () -> Void
    
    var body: some View {
        Button {
            function()
        } label: {
            image
            //Necesario para centrar los textos del header.
                .frame(width: FrameSize.width.headerButton,
                       height: FrameSize.height.headerButton)
                .font(.montserrat(size: .bigXXL))
                .foregroundColor(tintColor)
                .fontWeight(.ultraLight)
        }
    }
}

#Preview {
    VStack {
        ButtonNavigation() { print("pressed") }
        
        ButtonNavigation(image: Image.xmarkCircle, tintColor: Color.red) { print("pressed") }
        //.padding(.leading, -((saveSize.width / 2) - 20)) //If need to use ZStack.
    }
    .padding()
    .background(Color.backgroundBottom)
}
