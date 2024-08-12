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
                            onlyTitle: true)
            .padding(.vertical)
            
            
            PickerSegmented(selection: $newCategoryVM.model.categoryType,
                            segments: TransactionTypeEnum.allCases)
            .padding(.bottom)
            
            
            TextField("", text: $newCategoryVM.model.name,
                      prompt: Text("Name").foregroundColor(.textFieldPlaceholder))
            .textFieldStyle(TextFieldIconStyle($newCategoryVM.model.name,
                                               errorMessage: $newCategoryVM.errorMessage))
            
            TextField("", text: $newCategoryVM.model.icon,
                      prompt: Text("Icon").foregroundColor(.textFieldPlaceholder))
            .textFieldStyle(TextFieldIconStyle($newCategoryVM.model.icon,
                                               errorMessage: $newCategoryVM.errorMessage))
            .padding(.bottom)
            
            
            Button("Accept") {
                Task {
                    let result = await newCategoryVM.addNewCategory()
                    
                    if result.status.isSuccess {
                        dismiss()
                    } else {
                        newCategoryVM.errorMessage = result.message
                    }
                }
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $newCategoryVM.isLoading))
            .padding(.vertical)
            .padding(.bottom)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(ButtonPrimaryStyle(color: [Color.warning]))
            .padding(.horizontal)
            
            
            TextError(message: newCategoryVM.errorMessage)
        }
    }
}

#Preview {
    NewCategoryView()
}
