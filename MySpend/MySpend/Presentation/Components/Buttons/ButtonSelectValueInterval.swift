//
//  ButtonSelectValueInterval.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/10/24.
//

import SwiftUI

struct ButtonSelectValueInterval: View {
    
    var text: String
    
    let iconLeading: Image = Image.chevronLeft
    let iconTrailing: Image = Image.chevronRight
    
    let backgroundColor: Color = Color.secondaryLeading
    
    // MARK: ACTIONS
    let actionTrailing: () -> Void
    let actionCenter: () -> Void
    let actionLeading: () -> Void
    
    init(_ text: String,
         actionTrailing: @escaping () -> Void,
         actionCenter: @escaping () -> Void,
         actionLeading: @escaping () -> Void) {
        self.text = text
        self.actionTrailing = actionTrailing
        self.actionCenter = actionCenter
        self.actionLeading = actionLeading
    }
    
    var body: some View {
        VStack {
            HStack(spacing: ConstantViews.selectValueIntervalSpacing) {
                Button {
                    actionTrailing()
                } label: {
                    iconLeading
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: FrameSize.width.buttonSelectValueInterval,
                               height: FrameSize.height.buttonSelectValueInterval)
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
                    TextPlain(message: text)
                        .frame(width: FrameSize.width.buttonSelectValueIntervalCenter,
                               height: FrameSize.height.buttonSelectValueInterval)
                        .padding()
                        .background(backgroundColor)
                }
                .buttonStyle(ButtonScaleStyle())
                
                
                Button {
                    actionLeading()
                } label: {
                    iconTrailing
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: FrameSize.width.buttonSelectValueInterval,
                               height: FrameSize.height.buttonSelectValueInterval)
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
    ButtonSelectValueInterval("Today") {
        
    } actionCenter: {
        
    } actionLeading: {
        
    }
}
