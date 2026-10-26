//
//  SelectCategoryModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct SelectCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(CategoryManager.self) private var manager
    
    @Binding var selectedCategory: CategoryModel
    @Binding var type: CategoryType
    
    private var filteredCategories: [CategoryModel] {
        manager.sortedCategories.filter {
            $0.type == selectedCategory.type
        }
    }
    
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        VStack {
            CategoryPickerView(selection: $type)
                .glassEffect(.regular)
                .padding(.horizontal)
            
            List {
                if filteredCategories.isEmpty {
                    
                    Text(.categoriesEmpty)
                        .foregroundStyle(.secondary)
                    
                } else {
                    ForEach(filteredCategories) { item in
                        Button {
                            selectedCategory = item
                            dismiss()
                            
                        } label: {
                            HStack {
                                Label(item.name, systemImage: item.icon)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        .tag(item)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .animation(.default, value: filteredCategories)
        }
        .navigationTitle(.categoriesTitle)
        .navigationSubtitle(.categorySelectSubtitle)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Menu(.menuOptionsTitle, systemImage: ConstantSystemImage.options) {
                    CategorySortMenu()
                }
                .menuOrder(.fixed)
                .disabled(filteredCategories.isEmpty)
            }
            
            
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .close) {
                    dismiss()
                }
            }
        }
        
        .presentationDetents([.medium, .large], selection: $selectedDetent)
        .presentationBackground {
            if selectedDetent == .large {
                Color.backgroundGradient
            }
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, local: String = Previews.localeES_CR) {
        _manager = State(initialValue: CategoryManager(viewContext: mockDataType.viewContext))
        self.local = local
    }
    
    var local: String
    
    @State var manager = CategoryManager.shared
    
    @State var model = CategoryModel()
    @State var type = CategoryType.expense
    
    @State var show: Bool = false
    
    var body: some View {
        VStack {
            Button(.categoriesTitle) {
                show = true
            }
        }
        .sheet(isPresented: $show) {
            NavigationStack {
                SelectCategoryView(selectedCategory: $model, type: $type)
            }
        }
        .onAppear {
            show = true
        }
        .environment(manager)
        .environment(\.locale, .init(identifier: local))
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper(.normal, local: Previews.localeES_CR)
}

#Preview("Saturated \(Previews.localeEN)") {
    previewWrapper(.saturated, local: Previews.localeEN)
}

#Preview("Empty \(Previews.localeES)") {
    previewWrapper(.empty, local: Previews.localeES)
}
