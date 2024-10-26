//
//  NewCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct NewCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var model: CategoryModel
    @StateObject var viewModel = NewCategoryViewModel()
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: "New category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Enter the category details",
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
                .onSubmit { process() }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: model.icon, actionClear: {
                    model.icon = ""
                }))
            }
            
            
            // MARK: BUTTONS
            VStack {
                Button("Add") {
                    process()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .padding(.vertical)
                
                
                TextError(message: viewModel.errorMessage)
            }
        }
        .disabled(viewModel.isLoading)
        .sheet(isPresented: $viewModel.showIconsModal) {
            IconListModalView(model: $model, showModal: $viewModel.showIconsModal)
        }
    }
     
    private func process() {
        Task {
            let result = await viewModel.addNewCategory(model)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("Add new category") {
    NewCategoryView(model: CategoryModel())
}
