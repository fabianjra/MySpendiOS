//
//  UpdateCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/26.
//

import SwiftUI

struct UpdateCategoryView: View {
    
    @Binding var category: CategoryModel
    
    var body: some View {
        Text(category.name)
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State var manager = CategoryManager.shared
    @State var category = CategoryModel()
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            List(manager.sortedCategories) { item in
                Button(item.name) {
                    self.category = item
                    isPresented = true
                }
            }
        }
        .onChange(of: manager.sortedCategories, initial: true) { _, items in
            guard let firstItem = items.first else {
                return
            }
            
            category = firstItem
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                UpdateCategoryView(category: $category)
            }
        }
        .environment(manager)
    }
}

#Preview(Previews.localeES_CR) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
