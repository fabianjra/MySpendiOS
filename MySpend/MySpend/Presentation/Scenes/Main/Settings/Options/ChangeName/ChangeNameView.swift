//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI
import Firebase

struct ChangeNameView: View {
    
    @StateObject var changeNameVM = ChangeNameViewModel()
    
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
                
                TextFieldReadOnly(text: $changeNameVM.changeName.userName, iconLeading: Image.personFill)
                
                
                TextFieldName(placeHolder: "New name",
                              text: $changeNameVM.changeName.newUserName,
                              iconLeading: Image.checkmark,
                              errorMessage: $changeNameVM.changeName.errorMessage)
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
                .disabled(changeNameVM.changeName.buttonDisabled)
                
                
                TextError(message: changeNameVM.changeName.errorMessage)
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
