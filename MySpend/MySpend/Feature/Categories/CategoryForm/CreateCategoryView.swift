//
//  ModifyCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct CreateCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(CategoryManager.self) private var manager
    
    @Binding var categoryType: CategoryType
    
    @State private var category = CategoryModel()
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        
        CategoryForm(category: $category, type: $categoryType)
        
            .navigationTitle(.categoryCreateTitle)
        //.navigationSubtitle(.categoryCreateSubtitle)
        
            .safeAreaInset(edge: .bottom) {
                Button {
                    Task {
                        toastResponse = await manager.create(category, type: categoryType)
                        if toastResponse?.type == .ok {
                            dismiss()
                        }
                    }
                } label: {
                    Text(.buttonSave)
                        .padding(.vertical, ConstantViews.paddingButtonVertical)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                }
                .padding(.horizontal)
                .buttonStyle(.glass)
                .padding(.bottom)
                .disabled(toastResponse != nil)
            }
        
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
        
            .background {
                Color.backgroundGradient
                    .ignoresSafeArea(.container, edges: .all)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        
            .toast($toastResponse)
    }
}


#Preview(Previews.localeES_CR) {
    
    @Previewable @State var manager = CategoryManager.shared
    @Previewable @State var type = CategoryType.expense
    
    NavigationStack {
        CreateCategoryView(categoryType: $type)
    }
    .environment(manager)
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
