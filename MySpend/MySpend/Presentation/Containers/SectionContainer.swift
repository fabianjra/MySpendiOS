//
//  SectionContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct SectionContainer<Content: View>: View {
    
    let header: String?
    let isInsideList: Bool
    let headerColor: Color
    let headerSize: Font.Sizes
    var content: () -> Content
    
    init(header: String? = nil,
         isInsideList: Bool? = true,
         headerColor: Color = Color.textSecondaryForeground,
         headerSize: Font.Sizes = .small,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.header = header
        self.isInsideList = isInsideList ?? true
        self.headerColor = headerColor
        self.headerSize = headerSize
        self.content = content
    }
    
    var body: some View {
        Section(content: content, header: {
            if let header = header {
                
                if isInsideList {
                    Text(header)
                        .foregroundColor(headerColor)
                        .font(.montserrat(size: headerSize))
                } else {
                    HStack {
                        Text(header)
                            .foregroundColor(headerColor)
                            .font(.montserrat(size: headerSize))
                            .padding(.leading)
                        
                        Spacer()
                    }
                }
            }
        })
        .listRowBackground(Color.listRowBackground)
    }
}

#Preview {
    VStack {
        ContentContainer(addPading: false) {
            ListContainer {
                SectionContainer(header: "Header for section") {
                    Text("Content of section")
                }
                
                SectionContainer {
                    Text("Content without header")
                    Text("Item 2")
                }
            }
        }
        
        VStack {
            SectionContainer(header: "HEADER WHEN IS NOT A LIST",
                             isInsideList: false,
                             headerSize: .small) {
                TextFieldName(text: .constant(""),
                              errorMessage: .constant(""))
            }
        }
        .padding()
        .background(Color.background)
    }
}
