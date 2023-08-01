//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI
import Firebase

struct ChangeNameView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var userName: String = ""
    
    @State private var newUserName: String = ""
    @State private var isNewUserNameError: Bool = false

    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var user = Auth.auth().currentUser
    
    var body: some View {
        FormScrollContainer {
            
            //MARK: HEADER
            HStack {
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                TextTitleForm(title: "Change name",
                              titleWeight: .regular,
                              titleSize: .bigXL,
                              subTitle: "Fill the name space",
                              subTitleWeight: .regular)
                    
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
            .padding(.bottom)

            
            //MARK: FIELDS
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
            if let user = user {
                let displayName: String? = user.displayName

                userName = displayName ?? ""
            } else {
                errorMessage = ErrorMessages.userNotLoggedIn.localizedDescription
            }
        }
    }
    
    private func changeName() {
        
        isNewUserNameError = newUserName.isEmptyOrWhitespace()
        
        if isNewUserNameError {
            errorMessage = ErrorMessages.emptySpace.localizedDescription
            
        } else {
            
            let changeRequest = user?.createProfileChangeRequest()
            changeRequest?.displayName = newUserName
            changeRequest?.photoURL = nil
            
            changeRequest?.commitChanges { error in
               
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    errorMessage = "NAME CHANGED! Go back."
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
