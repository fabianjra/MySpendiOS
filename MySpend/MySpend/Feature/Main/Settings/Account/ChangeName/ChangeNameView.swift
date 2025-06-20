//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct ChangeNameView: View {
    
    @StateObject private var viewModel = ChangeNameViewModel()
    
    @FocusState private var focusedField: ChangeName.Field?
    
    var body: some View {
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Change name",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Fill the name space",
                            subTitleWeight: .regular)
            .padding(.bottom)
            
            
            // MARK: FIELDS
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldReadOnly(text: $viewModel.model.userName, iconLeading: Image.personFill)
                
                
                TextFieldName(placeHolder: "New name",
                              text: $viewModel.model.newUserName,
                              iconLeading: Image.checkmark,
                              errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .focused($focusedField, equals: .newUserName)
                .onSubmit {
                    Task {
                        await viewModel.changeUserName()
                    }
                }
                
                
                Button("Change name") {
                    Task {
                        await viewModel.changeUserName()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                .disabled(viewModel.disabled)
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .onAppear {
            focusedField = .newUserName
            viewModel.onAppear()
        }
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    ChangeNameView()
}
