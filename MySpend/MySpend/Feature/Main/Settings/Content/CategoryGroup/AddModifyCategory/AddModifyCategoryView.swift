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
    
    @Binding var categoryType: TransactionType
    
    // Options for: Category added from New Transaction (Should select the new category when added).
    @Binding var isNewCategoryAdded: Bool //Allows the dismiss in the UpperView when a new category is added.
    @Binding var newCategoryID: String
    
    @StateObject var viewModel = AddModifyCategoryViewModel()
    @FocusState private var focusedField: CategoryModel.Field?
    
    private let isNewCategory: Bool
    
    var modelBinding: Binding<CategoryModel> {
        Binding(
            get: { isNewCategory ? defaultModel : model }, /// Use defaultModel when is a New Category
            set: { newValue in
                if isNewCategory {
                    defaultModel = newValue /// Get the default model when is a New Category.
                } else {
                    model = newValue /// Use the model passed by parameter when is a Modify Category.
                }
            }
        )
    }
    
    /// Way to initialize a Binding if you want to pass a value (model) or just initialize the model with default valures.
    init(model: Binding<CategoryModel>? = nil,
         categoryType: Binding<TransactionType>,
         
         isNewCategoryAdded: Binding<Bool>? = nil,
         newCategoryID: Binding<String>? = nil) {
        
        if let model = model {
            self.isNewCategory = false
            self._model = model
        } else {
            /// In case a model is no passed by parameter, wont be use model. Will use defaultModel instead.
            self.isNewCategory = true
            self._model = .constant(CategoryModel())
        }
        
        self._categoryType = categoryType
        
        if let isNewCategoryAdded = isNewCategoryAdded {
            self._isNewCategoryAdded = isNewCategoryAdded
        } else {
            self._isNewCategoryAdded = .constant(false)
        }
        
        if let newCategoryID = newCategoryID {
            self._newCategoryID = newCategoryID
        } else {
            self._newCategoryID = .constant("")
        }
    }
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: isNewCategory ? "New category" : "Modify category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: isNewCategory ? "Enter the category details" : "Modify the category details",
                            showLeadingAction: false,
                            showTrailingAction: true)
                .padding(.vertical)
            
            
            // MARK: SEGMENT
            VStack {
                PickerSegmented(selection: $categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldCategoryName(text: modelBinding.name,
                                      errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process(isNewCategory ? .add : .modify) }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: modelBinding.wrappedValue.icon, actionClear: {
                    modelBinding.wrappedValue.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button(isNewCategory ? "Add" : "Modify") {
                    process(isNewCategory ? .add : .modify)
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                
                if isNewCategory == false {
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
        Task {
            let result: ResponseModel
            
            switch processType {
            case .add:
                result = await viewModel.addNewCategory(modelBinding.wrappedValue, categoryType: categoryType)
            case .modify:
                result = await viewModel.modifyCategory(modelBinding.wrappedValue, categoryType: categoryType)
            case .delete:
                result = await viewModel.deleteCategory(modelBinding.wrappedValue)
            }
            
            if result.status.isSuccess {
                guard let documentReference = result.documentReference else {
                    dismiss()
                    return
                }
                
                newCategoryID = documentReference.documentID
                isNewCategoryAdded = true
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}


#Preview("New") {
    @Previewable @State var categoryType = MocksCategories.expense1.categoryType
    VStack {
        AddModifyCategoryView(categoryType: $categoryType, isNewCategoryAdded: .constant(false))
    }
}

#Preview("Modify") {
    @Previewable @State var model = MocksCategories.expense1
    @Previewable @State var categoryType = MocksCategories.expense2.categoryType
    VStack {
        AddModifyCategoryView(model: $model, categoryType: $categoryType, isNewCategoryAdded: .constant(false))
    }
}
