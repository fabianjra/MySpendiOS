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
                Spacer()
                
                Text(.transactionsEmpty)
                    .font(.title)
                    .fontDesign(.rounded)
                    .padding(.vertical)
                
                Spacer()
            }
            
            Text(.transactionEmptyAddNewItem)
                .font(Font.callout.weight(.light))
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .lineLimit(ConstantViews.messageMaxLines)
            
            Spacer()
        }
    }
}

#Preview(Previews.localeES) {
    TransactionsEmptyView()
        .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    TransactionsEmptyView()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
