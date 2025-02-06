//
//  SectionContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct SectionContainer<Content: View>: View {
    
    private let title: String?
    private let isInsideList: Bool
    private let textColor: Color
    private let textSize: Font.Sizes
    private let rowColor: Color
    private let content: () -> Content
    
    init(_ title: String? = nil,
         isInsideList: Bool? = true,
         textColor: Color = Color.textSecondaryForeground,
         textSize: Font.Sizes = .small,
         rowColor: Color = Color.listRowBackground,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.title = title
        self.isInsideList = isInsideList ?? true
        self.textColor = textColor
        self.textSize = textSize
        self.rowColor = rowColor
        self.content = content
    }
    
    var body: some View {
        Section(content: content, header: {
            if let title = title {
                
                if isInsideList {
                    TextPlain(title, color: textColor, size: textSize)
                } else {
                    HStack {
                        TextPlain(title, color: textColor, size: textSize)
                            .padding(.leading)
                        
                        Spacer()
                    }
                }
            }
        })
        .listRowBackground(rowColor)
    }
}

#Preview {
    VStack {
        ContentContainer(addPading: false) {
            ListContainer {
                SectionContainer("Header for section") {
                    Text("Content of section")
                }
                
                SectionContainer {
                    Text("Content without header")
                    Text("Item 2")
                }
            }
        }
        
        VStack {
            SectionContainer("HEADER WHEN IS NOT A LIST",
                             isInsideList: false) {
                TextFieldName(text: .constant(""),
                              errorMessage: .constant(""))
            }
        }
        .padding()
        .background(Color.backgroundBottom)
    }
}
