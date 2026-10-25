//
//  UpdateCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/26.
//

import SwiftUI

struct UpdateCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(CategoryManager.self) private var manager
    
    @Binding var category: CategoryModel
    
    @State private var showAlert = false
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        
        CategoryDetailEdit(category: $category, categoryType: $category.type)
        
            .navigationTitle(.categoryUpdateTitle)
        //.navigationSubtitle(.categoryUpdateSubtitle)
        
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        Task {
                            toastResponse = await manager.update(category)
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
                    
                    Button(.alertOptionDelete, role: .destructive) {
                        showAlert = true
                    }
                    .padding(.bottom)
                }
                
                .alert(.categoryDelete(.zero), isPresented: $showAlert) {
                    Button(.alertOptionDelete, role: .destructive) {
                        Task {
                            toastResponse = await manager.delete(category)
                            
                            if toastResponse?.type == .ok {
                                dismiss()
                            }
                        }
                    }
                    
                    Button(.alertOptionCancel, role: .cancel) { }
                } message: {
                    Text(.categoryDeleteMessage(.zero))
                }
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
