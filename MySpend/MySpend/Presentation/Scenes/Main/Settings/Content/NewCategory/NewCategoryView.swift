//
//  NewCategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct NewCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var newCategoryVM = NewCategoryViewModel()
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: "New category",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Enter the new category details",
                            showLeadingAction: false,
                            showTrailingAction: true) { dismiss() }
            .padding(.vertical)
            
            
            // MARK: SEGMENT
            
            VStack {
                PickerSegmented(selection: $newCategoryVM.model.categoryType,
                                segments: TransactionTypeEnum.allCases)
                .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            
            VStack {
                TextField("", text: $newCategoryVM.model.name,
                          prompt: Text("Name").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($newCategoryVM.model.name,
                                                   errorMessage: $newCategoryVM.errorMessage))
                .keyboardType(.alphabet)
                .onSubmit { process() }
                
                TextField("", text: $newCategoryVM.model.icon,
                          prompt: Text("Icon").foregroundColor(.textFieldPlaceholder))
                .textFieldStyle(TextFieldIconStyle($newCategoryVM.model.icon,
                                                   errorMessage: $newCategoryVM.errorMessage))
                .padding(.bottom)
            }
            
            
            // MARK: BUTTONS
            
            VStack {
                Button("Accept") {
                    process()
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $newCategoryVM.isLoading))
                .padding(.vertical)
                

                TextError(message: newCategoryVM.errorMessage)
            }
        }
    }
    
    private func process() {
        Task {
            let result = await newCategoryVM.addNewCategory()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                newCategoryVM.errorMessage = result.message
            }
        }
    }
}

#Preview {
    NewCategoryView()
}
