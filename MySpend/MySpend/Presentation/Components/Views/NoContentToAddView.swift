//
//  NoContentToAddView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/24.
//

import SwiftUI

struct NoContentToAddView: View {
    
    var rotationDegress: CGFloat = ConstantAnimations.rotationArrowBottomCenter
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextPlainLocalized(Localizable.Data.empty,
                                   family: .semibold,
                                   size: .bigXL,
                                   aligment: .center)
                .padding(.vertical)
                Spacer()
            }
            
            TextPlainLocalized(Localizable.Data.empty_add_item,
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

#Preview(Previews.localeES) {
    VStack {
        NoContentToAddView()
            .background(Color.backgroundBottom)
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    VStack {
        NoContentToAddView()
            .background(Color.backgroundBottom)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
