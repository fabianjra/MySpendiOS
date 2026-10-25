//
//  CategoryDetailEdit.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/26.
//

import SwiftUI

struct CategoryDetailEdit: View {
    
    // PARAMETRIZADOS
    @Binding var category: CategoryModel
    @Binding var categoryType: CategoryType
    
    // LOCALES
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            CategoryPickerView(selection: $categoryType)
                .glassEffect(.regular)
                .padding(.horizontal)
            
            Form {
                Section {
                    LabeledContent(.inputName) {
                        TextField(.categoryInputNamePlaceHolder, text: $category.name)
                            .formInputStyle($category.name)
                            .keyboardType(.alphabet)
                            .focused($isFocused)
                    }
                    .formLabeledInputStyle
                    
                    
                    LabeledContent(.inputIcon) {
                        Button {
                            showIconsModal = true
                        } label: {
                            if category.icon.isEmptyOrWhitespace {
                                Text(.inputIconPlaceHolder)
                                    .foregroundStyle(Color(uiColor: .placeholderText))
                                
                            } else {
                                Image(systemName: category.icon)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        
                        Spacer()
                        
                        if !category.icon.isEmptyOrWhitespace {
                            Button {
                                category.icon = ""
                            } label: {
                                Text(.selectorClear)
                            }
                            .buttonStyle(.borderless) // Permite la accion de borrar el icono sin irse a la accion de mostrar modal.
                        }
                    }
                    .formLabeledInputStyle
                    
                } footer: {
                    Text(.inputNameRequired)
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
        }
        
        .onAppear {
            isFocused = true
        }
        .onChange(of: selectedIcon) { _, newValue in
            category.icon = newValue
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon)
        }
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var category = CategoryModel()
    @Previewable @State var isDefaultSelected = false
    
    CategoryDetailEdit(category: $category, categoryType: $category.type)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}


#Preview(Previews.localeEN) {
    
    @Previewable @State var category = CategoryModel()
    @Previewable @State var isDefaultSelected = false
    
    CategoryDetailEdit(category: $category, categoryType: $category.type)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
