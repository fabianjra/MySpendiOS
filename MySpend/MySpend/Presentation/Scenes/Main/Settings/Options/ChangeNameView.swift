//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct ChangeNameView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var userName: String = "Actual name"
    
    @State private var newUserName: String = ""
    @State private var isNewUserNameError: Bool = false

    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        
        FormContainer {
            
            //MARK: HEADER
            HStack {
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                TextTitleForm(title: "Change name",
                              titleWeight: .regular,
                              titleSize: .bigXL,
                              subTitle: "Type your new name",
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
    }
    
    private func changeName() {
        print("New user name: \(newUserName)")
        
        if newUserName.isEmptyOrWhitespace() {
            canSubmit = false
            errorMessage = "Fill the new user name text field"
        } else {
            canSubmit = true
        }
        
        //If Textfields are empty, bool error will be true.
        isNewUserNameError = newUserName.isEmptyOrWhitespace()
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView()
    }
}
