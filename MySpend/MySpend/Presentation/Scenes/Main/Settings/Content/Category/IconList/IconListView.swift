//
//  IconListView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/10/24.
//

import SwiftUI

struct IconListView: View {
    
    var icon: Icons
    var action: (String) -> Void
    
    var body: some View {
        VStack {
            SectionContainer(header: icon.rawValue, isInsideList: false, headerSize: .body) {
                
                let columns = [
                    GridItem(.adaptive(minimum: ConstantViews.gridSpacing))
                ]
                
                LazyVGrid(columns: columns, alignment: .center, spacing: ConstantViews.formSpacing) {
                    ForEach(icon.list, id: \.self) { icon in
                        Button {
                            action(icon)
                        } label: {
                            Image(systemName: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: FrameSize.width.iconShowcase,
                                       height: FrameSize.height.iconShowcase)
                                .tint(Color.textPrimaryForeground)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    IconListView(icon: Icons.bills) { _ in }
        .background(Color.backgroundContentGradient)
}
