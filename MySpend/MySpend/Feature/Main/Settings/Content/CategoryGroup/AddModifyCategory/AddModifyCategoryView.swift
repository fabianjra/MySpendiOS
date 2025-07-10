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
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var model: CategoryModel
    @State private var defaultModel = CategoryModel()
    
    @Binding var modelType: CategoryType
    
    // Options for: Category added from New Transaction (Should select the new category when added).
    @Binding var isNewModelAdded: Bool //Allows the dismiss in the UpperView when a new category is added.
    @Binding var newModelID: String
    
    @StateObject var viewModel = AddModifyCategoryViewModel()
    @FocusState private var focusedField: CategoryModel.Field?
    
    private let isNewModel: Bool
    
    var modelBinding: Binding<CategoryModel> {
        Binding(
            get: { isNewModel ? defaultModel : model }, /// Use defaultModel when is a New Category
            set: { newValue in
                if isNewModel {
                    defaultModel = newValue /// Get the default model when is a New Category.
                } else {
                    model = newValue /// Use the model passed by parameter when is a Modify Category.
                }
            }
        )
    }
    
    /// Way to initialize a Binding if you want to pass a value (model) or just initialize the model with default valures.
    init(model: Binding<CategoryModel>? = nil,
         categoryType: Binding<CategoryType>,
         
         isNewCategoryAdded: Binding<Bool>? = nil,
         newCategoryID: Binding<String>? = nil) {
        
        if let model = model {
            self.isNewModel = false
            self._model = model
        } else {
            /// In case a model is no passed by parameter, wont be use model. Will use defaultModel instead.
            self.isNewModel = true
            self._model = .constant(CategoryModel())
        }
        
        self._modelType = categoryType
        
        if let isNewCategoryAdded = isNewCategoryAdded {
            self._isNewModelAdded = isNewCategoryAdded
        } else {
            self._isNewModelAdded = .constant(false)
        }
        
        if let newCategoryID = newCategoryID {
            self._newModelID = newCategoryID
        } else {
            self._newModelID = .constant("")
        }
    }
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: isNewModel ? "New category" : "Modify category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: isNewModel ? "Enter the category details" : "Modify the category details",
                            showLeadingAction: false,
                            showTrailingAction: true)
                .padding(.vertical)
            
            
            // MARK: SEGMENT
            VStack {
                PickerSegmented(selection: $modelType,
                                segments: CategoryType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldCategoryName(text: modelBinding.name,
                                      errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process(isNewModel ? .add : .modify) }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: modelBinding.wrappedValue.icon, actionClear: {
                    modelBinding.wrappedValue.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button(isNewModel ? "Add" : "Modify") {
                    process(isNewModel ? .add : .modify)
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                
                if isNewModel == false {
                    Button("Delete") {
                        viewModel.showAlert = true
                    }
                    .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold, isLoading: $viewModel.isLoadingSecondary))
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
        .sheet(isPresented: $viewModel.showIconsModal) {
            IconListModalView(model: modelBinding, showModal: $viewModel.showIconsModal)
        }
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
    }
    
    private func process(_ processType: ProcessType) {
        let result: ResponseModel
        
        switch processType {
        case .add:
            result = viewModel.addNew(modelBinding.wrappedValue, type: modelType)
        case .modify:
            result = viewModel.modify(modelBinding.wrappedValue, type: modelType)
        case .delete:
            result = viewModel.delete(modelBinding.wrappedValue)
        }
        
        if result.status.isSuccess {
            if processType == .add {
                newModelID = modelBinding.id.uuidString
                isNewModelAdded = true
            }
            
            dismiss()
        } else {
            viewModel.errorMessage = result.message
        }
    }
}


#Preview("New") {
    @Previewable @State var categoryType = MocksCategoriesFB.expense1.categoryType
    VStack {
        AddModifyCategoryView(categoryType: $categoryType,
                              isNewCategoryAdded: .constant(false))
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
