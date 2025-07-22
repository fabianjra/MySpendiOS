//
//  ModifyCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

/**
 This view can be instantiated with a model or without a model.
 Pass a model of type `CategoryModel` if you want to modify something on it, eg: when you want to modify a category.
 If you don't pass a model by parameter, the `bool` let `isNewCategory` will be set to true, because will use an internal @State model inside to
 manage the model data in the view and no the Binding model used for paraemter.
 
 - Parameters:
    - model: This model should be passed only when you want to modify something in the model already loaded.
    - categoryType: The type of category, is Expense or Income for the initial value.

 - Date: December 2024
 */
struct AddModifyCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var categoryType: CategoryType
    
    // Variables para validar si el Modal viene desde la seleccion de categoria (para asignarla a la seleccionada en la vista de AddModifyTransaction)
    // o si es desde el mantenimiento, para solamente agregarla o modificarla.
    @Binding var newCategoryID: UUID
    private let isSelectionMode: Bool
    @Binding var isNewModelAdded: Bool
    
    @StateObject private var viewModel: AddModifyCategoryViewModel
    @FocusState private var focusedField: CategoryModel.Field?
    
    init(_ model: CategoryModel? = nil,
         categoryType: Binding<CategoryType>,
         newCategoryID: Binding<UUID> = .constant(UUID()),
         isSelectionMode: Bool = false,
         isNewModelAdded: Binding<Bool> = .constant(false)) {
        
        _viewModel = StateObject(wrappedValue: AddModifyCategoryViewModel(model))
        
        self._categoryType = categoryType
        self._newCategoryID = newCategoryID
        self.isSelectionMode = isSelectionMode
        self._isNewModelAdded = isNewModelAdded
    }
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: viewModel.isAddModel ? "New category" : "Modify category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: viewModel.isAddModel ? "Enter the category details" : "Modify the category details",
                            showLeadingAction: false,
                            showTrailingAction: true)
                .padding(.vertical)
            
            
            // MARK: SEGMENT
            VStack {
                PickerView(selection: $categoryType)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                    .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldModelName(text: $viewModel.model.name,
                                      errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process(viewModel.isAddModel ? .add : .modify) }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: viewModel.model.icon, actionClear: {
                    viewModel.model.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button(viewModel.isAddModel ? "Add" : "Modify") {
                    process(viewModel.isAddModel ? .add : .modify)
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.vertical)
                
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
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .onAppear {
            focusedField = .name
            
            if viewModel.isAddModel == false {
                categoryType = viewModel.model.type
            }
        }
        .sheet(isPresented: $viewModel.showIconsModal) {
            IconListModalView(model: $viewModel.model, showModal: $viewModel.showIconsModal)
        }
    }
    
    private func process(_ processType: ProcessType) {
        let result: ResponseModel
        
        switch processType {
        case .add:
            result = viewModel.addNew(type: categoryType)
        case .modify:
            result = viewModel.modify(type: categoryType)
        case .delete:
            result = viewModel.delete()
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


#Preview("New") {
    @Previewable @State var categoryType: CategoryType = .expense
    
    VStack {
        AddModifyCategoryView(categoryType: $categoryType)
    }
}

// TOD: REPARAR
//#Preview("Modify") {
//    @Previewable @State var model = MocksCategoriesFB.expense1
//    @Previewable @State var categoryType = MocksCategoriesFB.expense2.categoryType
//    VStack {
//        AddModifyCategoryView(model: $model, categoryType: $categoryType, isNewCategoryAdded: .constant(false))
//    }
//}
