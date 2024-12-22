//
//  MenuContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/12/24.
//

import SwiftUI

struct MenuContainer<Content: View>: View {
    
    private let title: String
    private let disabled: Bool
    
    var content: () -> Content
    
    init(_ title: String = "Sort",
         disabled: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.disabled = disabled
        self.content = content
    }
    
    var body: some View {
        Menu(title, content: content)
            .menuOrder(.fixed)
            .foregroundStyle(disabled ? Color.disabledForeground : Color.buttonForeground)
    }
}

#Preview("Menu sort") {
    MenuContainer() {
        Section("Sort by") {
            Button {
                //Sort
            } label: {
                Label.dateNewestFirst
            }
            
            Button {
                //Sort
            } label: {
                Label.amountLowestFirst
            }
        }
    }
    .background(Color.backgroundBottom)
}
