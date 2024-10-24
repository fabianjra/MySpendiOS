//
//  NewCategoryModalContent.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/10/24.
//

import SwiftUI

struct NewCategoryModalContent: View {
    
    var header: String
    var arrayIcons: [String]
    var action: (String) -> Void
    
    var body: some View {
        VStack {
            SectionContainer(header: header, isInsideList: false, headerSize: .body) {
                
                let columns = [
                    GridItem(.adaptive(minimum: ConstantViews.gridSpacing))
                ]
                
                LazyVGrid(columns: columns, alignment: .center, spacing: ConstantViews.formSpacing) {
                    ForEach(arrayIcons, id: \.self) { icon in
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

#Preview("Content Modal") {
    NewCategoryModalContent(header: "Bills", arrayIcons: ConstantIcons.iconList.first!.list) { _ in }
        .background(Color.backgroundContentGradient)
}
