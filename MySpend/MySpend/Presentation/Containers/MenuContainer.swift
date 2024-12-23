//
//  MenuContainer.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/12/24.
//

import SwiftUI

struct MenuContainer<Content: View>: View {
    
    private let title: String
    private let addHorizontalPadding: Bool
    private let disabled: Bool
    
    var content: () -> Content
    
    init(_ title: String = "Sort",
         addHorizontalPadding: Bool = false,
         disabled: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.addHorizontalPadding = addHorizontalPadding
        self.disabled = disabled
        self.content = content
    }
    
    var body: some View {
        Menu(content: content) {
            TextPlain(title)
                .padding(.trailing, addHorizontalPadding ? nil : .zero)
        }
        .menuOrder(.fixed)
        .foregroundStyle(disabled ? Color.disabledForeground : Color.buttonForeground)
    }
}

#Preview("Menu sort") {
    MenuContainer(addHorizontalPadding: true) {
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
