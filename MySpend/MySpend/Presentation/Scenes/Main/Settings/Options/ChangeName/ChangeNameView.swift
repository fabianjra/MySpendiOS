//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI
import Firebase

struct ChangeNameView: View {
    
    @StateObject private var changeNameVM = ChangeNameViewModel()
    
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
                
                TextFieldReadOnly(text: $changeNameVM.model.userName, iconLeading: Image.personFill)
                
                
                TextFieldName(placeHolder: "New name",
                              text: $changeNameVM.model.newUserName,
                              iconLeading: Image.checkmark,
                              errorMessage: $changeNameVM.model.errorMessage)
                .padding(.bottom)
                .submitLabel(.done)
                .onSubmit {
                    Task {
                        await changeNameVM.changeUserName()
                    }
                }
                
                
                Button("Change name") {
                    Task {
                        await changeNameVM.changeUserName()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $changeNameVM.isLoading))
                .padding(.bottom)
                .disabled(changeNameVM.model.disabled)
                
                
                TextError(message: changeNameVM.model.errorMessage)
            }
        }
        .disabled(changeNameVM.isLoading)
        .onAppear {
            changeNameVM.onAppear()
        }
    }
}

#Preview {
    ChangeNameView()
}
