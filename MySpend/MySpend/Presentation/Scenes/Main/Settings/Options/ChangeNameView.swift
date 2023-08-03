//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI
import Firebase

struct ChangeNameView: View {
    
    @State private var userName: String = ""
    
    @State private var newUserName: String = ""
    @State private var isNewUserNameError: Bool = false

    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Change name",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Fill the name space",
                            subTitleWeight: .regular)
            .padding(.bottom)

            
            // MARK: FIELDS
            VStack(spacing: Views.formSpacing) {
                
                TextFieldReadOnly(text: $userName, iconLeading: Image.personFill)
                
                
                TextFieldName(placeHolder: "New name",
                              text: $newUserName,
                              iconLeading: Image.checkmark,
                              isError: $isNewUserNameError,
                              errorMessage: $errorMessage)
                .padding(.bottom)
                .submitLabel(.done)
                .onSubmit { changeName() }
                
                
                Button("Change name") {
                    changeName()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                
                
                TextError(message: errorMessage)
            }
        }
        .onAppear {
            SessionStore.getUserName { name, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    userName = name
                }
            }
        }
    }
    
    private func changeName() {
        
        isNewUserNameError = newUserName.isEmptyOrWhitespace()
        
        if isNewUserNameError {
            errorMessage = ErrorMessages.emptySpace.localizedDescription
            
        } else {
            SessionStore.updateUserName(newUserName: newUserName,
                                        user: SessionStore.getCurrentUser()) { user, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    errorMessage = "NAME CHANGED TO: \(user?.displayName ?? "")"
                    canSubmit = true
                }
            }
        }
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView()
    }
}
