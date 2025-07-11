//
//  NoContentView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/24.
//

import SwiftUI

struct NoContentView: View {
    
    var title: String = "No Content"
    var message: String = "Try adding a new one in the plus (+) button"
    var rotationDegress: CGFloat = ConstantAnimations.rotationArrowBottomCenter
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextPlain(title,
                          family: .semibold,
                          size: .bigXL,
                          aligment: .center)
                .padding(.vertical)
                Spacer()
            }
            
            TextPlain(message,
                      size: .big,
                      aligment: .center,
                      lineLimit: ConstantViews.messageMaxLines)
            .padding(.bottom)
            
            Image.arrowTurnUpLeft
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FrameSize.width.iconAddNewData,
                       height: FrameSize.width.iconAddNewData)
                .fontWeight(.ultraLight)
                .foregroundStyle(Color.textPrimaryForeground)
                .rotationEffect(.degrees(rotationDegress))
            
            Spacer()
        }
    }
}

#Preview {
    VStack {
        NoContentView()
            .background(Color.backgroundBottom)
    }
}
