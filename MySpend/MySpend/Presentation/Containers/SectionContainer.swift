//
//  SectionContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct SectionContainer<Content: View>: View {
    
    let header: String?
    var content: () -> Content
    
    init(header: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content
    }
    
    var body: some View {
        Section(content: content, header: {
            if let header = header {
                Text(header)
                    .foregroundColor(Color.textSecondaryForeground)
                    .font(.montserrat(size: .small))
            }
        })
        .listRowBackground(Color.listRowBackground)
    }
}

struct SectionContainer_Previews: PreviewProvider {
    static var previews: some View {
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
}
