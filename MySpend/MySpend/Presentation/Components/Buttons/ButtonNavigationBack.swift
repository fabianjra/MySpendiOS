//
//  ButtonNavigationBack.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/23.
//

import SwiftUI

struct ButtonNavigationBack: View {
    
    let function: () -> Void
    
    var body: some View {
        Button {
            function()
        } label: {
            Image.chevronLeft
                .resizable()
                .frame(width: FrameSize.width.buttonBack, height: FrameSize.height.buttonBack)
                .foregroundColor(Color.textPrimaryForeground)
                .fontWeight(.ultraLight)
        }
    }
}

struct ButtonNavigationBack_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonNavigationBack { print("pressed") }
            //.padding(.leading, -((saveSize.width / 2) - 20)) //If need to use ZStack.
        }
        .padding()
        .background(Color.background)
    }
}
