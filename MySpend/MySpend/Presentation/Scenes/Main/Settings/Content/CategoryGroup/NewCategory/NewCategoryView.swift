//
//  NewCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct NewCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var categoryType: TransactionType
    @StateObject var viewModel = NewCategoryViewModel()
    @FocusState private var focusedField: CategoryModel.Field?
    
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
                PickerSegmented(selection: $categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            VStack {
                TextFieldCategoryName(text: $viewModel.model.name,
                                      errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process() }
                
                Button("") {
                    viewModel.showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: viewModel.model.icon, actionClear: {
                    viewModel.model.icon = ""
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
        .onAppear {
            focusedField = .name
        }
        .sheet(isPresented: $viewModel.showIconsModal) {
            IconListModalView(model: $viewModel.model, showModal: $viewModel.showIconsModal)
        }
        .disabled(viewModel.isLoading)
    }
     
    private func process() {
        Task {
            let result = await viewModel.addNewCategory(categoryType)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("Add new category") {
    NewCategoryView(categoryType: .constant(.expense))
}
