//
//  ButtonSelectValueInterval.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/24.
//

import SwiftUI

struct ButtonSelectValueInterval: View {
    
    let text: String = "This month"
    
    let iconLeading: Image = Image.chevronLeft
    let iconTrailing: Image = Image.chevronRight
    
    let backgroundColor: Color = Color.secondaryLeading
    
    // MARK: ACTIONS
    let actionTrailing: () -> Void
    let actionCenter: () -> Void
    let actionLeading: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: ConstantViews.selectValueIntervalSpacing) {
                Button {
                    actionTrailing()
                } label: {
                    iconLeading
                        .resizable()
                        .frame(width: FrameSize.width.buttonSelectValueInterval,
                               height: FrameSize.width.buttonSelectValueInterval)
                        .foregroundColor(Color.buttonForeground)
                        .padding()
                        .background(backgroundColor)
                        .clipShape(.rect(
                            topLeadingRadius: .infinity,
                            bottomLeadingRadius: .infinity)
                        )
                }
                .buttonStyle(ButtonScaleStyle())
                
                
                Button {
                    actionCenter()
                } label: {
                    TextPlain(message: text, size: .big)
                        .frame(height: FrameSize.height.buttonSelectValueIntervalCenter)
                        .frame(width: FrameSize.width.buttonSelectValueIntervalCenter)
                        .padding()
                        .background(backgroundColor)
                }
                .buttonStyle(ButtonScaleStyle())
                
                
                Button {
                    actionLeading()
                } label: {
                    iconTrailing
                        .resizable()
                        .frame(width: FrameSize.width.buttonSelectValueInterval,
                               height: FrameSize.width.buttonSelectValueInterval)
                        .foregroundColor(Color.buttonForeground)
                        .padding()
                        .background(backgroundColor)
                        .clipShape(.rect(
                            bottomTrailingRadius: .infinity,
                            topTrailingRadius: .infinity)
                        )
                }
                .buttonStyle(ButtonScaleStyle())
            }
        }
    }
}

#Preview {
    ButtonSelectValueInterval {
        
    } actionCenter: {
        
    } actionLeading: {
        
    }
}
