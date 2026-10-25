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
    
    // Variables para validar si el Modal viene desde la seleccion de categoria (para asignarla a la seleccionada en la vista de AddModifyTransaction)
    // o si es desde el mantenimiento, para solamente agregarla o modificarla.
    @Binding var newCategoryID: UUID
    private let isSelectionMode: Bool
    @Binding var isNewModelAdded: Bool
    
    @StateObject private var viewModel: CategoryDetailEditViewModel
    @FocusState private var focusedField: CategoryModel.Field?
    
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    init(_ model: CategoryModel? = nil,
         categoryType: Binding<CategoryType>,
         newCategoryID: Binding<UUID> = .constant(UUID()),
         isSelectionMode: Bool = false,
         isNewModelAdded: Binding<Bool> = .constant(false)) {
        
        _viewModel = StateObject(wrappedValue: CategoryDetailEditViewModel(model))
        
        self._categoryType = categoryType
        self._newCategoryID = newCategoryID
        self.isSelectionMode = isSelectionMode
        self._isNewModelAdded = isNewModelAdded
    }
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: viewModel.isAddModel ? "New category" : "Modify category",
                            titleWeight: .regular,
                            titleSize: .title,
                            subTitle: viewModel.isAddModel ? "Enter the category details" : "Modify the category details",
                            showLeadingAction: false,
                            showTrailingAction: true)
                .padding(.vertical)
            
            
            // MARK: SEGMENT
            VStack {
                CategoryPickerView(selection: $categoryType)
                    .glassEffect(.regular)
                    .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldModelName(text: $viewModel.model.name,
                                      errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process(viewModel.isAddModel ? .add : .modify) }
                
                Button("") {
                    showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: viewModel.model.icon, actionClear: {
                    viewModel.model.icon = ""
                }))
                
                TextError(viewModel.errorMessage)
                    .padding(.vertical)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button(action: {
                    process(viewModel.isAddModel ? .add : .modify)
                }, label: {
                    TextPlain(viewModel.isAddModel ? "Add" : "Modify")
                        .padding(.vertical, ConstantViews.paddingButtonVertical)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                })
                .buttonStyle(.glass)
                .padding(.bottom, viewModel.isAddModel ? nil : .zero)
                
                
                if viewModel.isAddModel == false {
                    Button("Delete") {
                        viewModel.showAlert = true
                    }
                    .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold))
                    .alert("Delete category", isPresented: $viewModel.showAlert) {
                        Button("Delete", role: .destructive) { process(.delete) }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this category? \n This action cannot be undone.")
                    }
                }
            }
            .padding(.horizontal)
        }
        
        .onAppear {
            if viewModel.isAddModel {
                focusedField = .name
            } else {
                categoryType = viewModel.model.type
            }
        }
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon)
        }
        .onChange(of: selectedIcon) { _, newValue in
            viewModel.model.icon = newValue
        }
    }
    
    private func process(_ processType: ProcessType) {
        Task {
            let result: ResponseModel
            
            switch processType {
            case .add:
                result = await viewModel.addNew(type: categoryType)
            case .modify:
                result = await viewModel.modify(type: categoryType)
            case .delete:
                result = await viewModel.delete()
            }
            
            if result.status.isSuccess {
                if processType == .add {
                    if isSelectionMode {
                        newCategoryID = viewModel.model.id
                        isNewModelAdded = true
                    }
                }
                
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
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
