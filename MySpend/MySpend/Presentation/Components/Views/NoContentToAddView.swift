//
//  NoContentToAddView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/24.
//

import SwiftUI

struct NoContentToAddView: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                TextPlainLocalized(Localizable.Data.empty,
                                   family: .semibold,
                                   size: .bigXL,
                                   aligment: .center)
                .padding(.vertical)
            }
            
            TextPlainLocalized(Localizable.Data.empty_add_item,
                               size: .big,
                               aligment: .center,
                               lineLimit: ConstantViews.messageMaxLines)
            
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
