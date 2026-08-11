//
//  NoContentToAddView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/10/24.
//

import SwiftUI

struct TransactionsEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text(.transactionsEmpty)
                    .textStyle(size: .bigXL)
                    .padding(.vertical)
            }
            
            Text(.transactionEmptyAddNewItem)
                .textStyle(family: .light,
                           size: .medium,
                           aligment: .center,
                           lineLimit: ConstantViews.messageMaxLines)
            
            Spacer()
        }
    }
}

#Preview(Previews.localeES) {
    TransactionsEmptyView()
        .background(Color.backgroundBottom)
        .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    TransactionsEmptyView()
        .background(Color.backgroundBottom)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
