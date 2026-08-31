//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct PersonalInformationView: View {

    @State private var viewModel = PersonalInformationViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        FormContainer {

            // MARK: FIELDS
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldReadOnly(placeHolder: "Name", text: $viewModel.username, iconLeading: Image.personFill)
                
                
                TextFieldName(placeHolder: "New name",
                              text: $viewModel.newUsername,
                              iconLeading: Image.checkmark,
                              errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .focused($isFocused)
                .onSubmit {
                        viewModel.changeUserName()
                }
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .navigationTitle("Change name")
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button(action: {
                    viewModel.changeUserName()
                }, label: {
                    TextPlain("Confirm")
                        .padding(.vertical, ConstantViews.paddingButtonTransaction)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                })
                .buttonStyle(.glass)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        
        .onAppear {
            isFocused = true
            viewModel.onAppear()
        }
    }
}

#Preview {
    NavigationStack {
        PersonalInformationView()
    }
}
