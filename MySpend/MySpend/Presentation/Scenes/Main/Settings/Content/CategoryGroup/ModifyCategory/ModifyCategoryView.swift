//
//  ModifyCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import SwiftUI

struct ModifyCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var model: CategoryModel
    @StateObject var viewModel = ModifyCategoryViewModel()
    
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
                PickerSegmented(selection: $model.categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldCategoryName(text: $model.name,
                                      errorMessage: $viewModel.errorMessage)
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: model.icon, actionClear: {
                    model.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button("Modify") {
                    process()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                
                //TODO: Cambiar estilo de boton por uno solamente bordes pintados.
                Button("Delete") {
                    viewModel.showAlert = true
                }
                .buttonStyle(ButtonPrimaryStyle(color: [Color.warning], isLoading: $viewModel.isLoadingSecondary))
                .padding(.vertical)
                .alert("Delete category", isPresented: $viewModel.showAlert) {
                    Button("Delete", role: .destructive) { delete() }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Want to delete this category? \n This action cannot be undone.")
                }
                
                
                TextError(message: viewModel.errorMessage)
            }
        }
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
        .sheet(isPresented: $viewModel.showIconsModal) {
            IconListModalView(model: $model, showModal: $viewModel.showIconsModal)
        }
    }
    
    private func process() {
        Task {
            let result = await viewModel.modifyCategory(model)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func delete() {
        Task {
            let result = await viewModel.deleteCategory(model)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview {
    @Previewable @State var model = CategoryModel(id: "",
                                                  icon: "envelope",
                                                  name: "Categoria sample",
                                                  categoryType: .income)
    VStack {
        ModifyCategoryView(model: $model)
    }
}
