//
//  NoContentToAddView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/24.
//

import SwiftUI

struct NoContentToAddView: View {
    
    var title: LocalizedStringKey = Localizations.view.empty.key
    var message: LocalizedStringKey = Localizations.view.empty_add_item.key
    var rotationDegress: CGFloat = ConstantAnimations.rotationArrowBottomCenter
    
    private let table = Tables.view
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextPlainLocalized(title,
                                   table: table,
                                   family: .semibold,
                                   size: .bigXL,
                                   aligment: .center)
                .padding(.vertical)
                Spacer()
            }
            
            TextPlainLocalized(message,
                               table: table,
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
