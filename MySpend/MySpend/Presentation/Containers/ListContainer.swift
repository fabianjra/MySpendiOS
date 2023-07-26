//
//  ListContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct ListContainer<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        List(content: content)
            .font(.montserrat())
            .foregroundColor(Color.listRowForeground)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.background)
    }
}

struct ListContainer_Previews: PreviewProvider {
    static var previews: some View {
        ListContainer {
            Text("Inside list container")
                .listRowBackground(Color.listRowBackground)
        }
    }
}
