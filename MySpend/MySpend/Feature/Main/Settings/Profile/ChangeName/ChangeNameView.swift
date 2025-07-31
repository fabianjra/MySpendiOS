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
                
                TextFieldReadOnly(placeHolder: "Name", text: $viewModel.model.username, iconLeading: Image.personFill)
                
                
                TextFieldName(placeHolder: "New name",
                              text: $viewModel.model.newUsername,
                              iconLeading: Image.checkmark,
                              errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .focused($focusedField, equals: .newUsername)
                .onSubmit {
                        viewModel.changeUserName()
                }
                
                
                Button("Change name") {
                        viewModel.changeUserName()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .disabled(viewModel.disabled)
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .onAppear {
            focusedField = .newUsername
            viewModel.onAppear()
        }
    }
}

#Preview {
    ChangeNameView()
}
