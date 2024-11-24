//
//  ModifyCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct ModifyCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var modelLoaded: CategoryModel
    @Binding var categoryType: TransactionType
    
    @StateObject var viewModel = ModifyCategoryViewModel()
    
    @FocusState private var focusedField: CategoryModel.Field?
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: "Modify category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Modify the category details",
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
                TextFieldCategoryName(text: $modelLoaded.name,
                                      errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process() }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: modelLoaded.icon, actionClear: {
                    modelLoaded.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button("Modify") {
                    process()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                
                
                Button("Delete") {
                    viewModel.showAlert = true
                }
                .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold, isLoading: $viewModel.isLoadingSecondary))
                .alert("Delete category", isPresented: $viewModel.showAlert) {
                    Button("Delete", role: .destructive) { delete() }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Want to delete this category? \n This action cannot be undone.")
                }
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .onAppear {
            focusedField = .name
        }
        .sheet(isPresented: $viewModel.showIconsModal) {
            IconListModalView(model: $modelLoaded, showModal: $viewModel.showIconsModal)
        }
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
    }
    
    private func process() {
        Task {
            let result = await viewModel.modifyCategory(modelLoaded, categoryType: categoryType)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func delete() {
        Task {
            let result = await viewModel.deleteCategory(modelLoaded)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview {
    @Previewable @State var model = CategoryModel(id: "01",
                                                  icon: "envelope",
                                                  name: "Categoria sample",
                                                  categoryType: .income)
    VStack {
        ModifyCategoryView(modelLoaded: $model, categoryType: .constant(.expense))
    }
}
