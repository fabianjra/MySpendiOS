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
    
    @State private var buttonDisabled: Bool = false
    @State private var isLoading: Bool = false
    
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
                .onSubmit {
                    Task {
                        await changeName()
                    }
                }
                
                
                Button("Change name") {
                    Task {
                        await changeName()
                    }
                }
                .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
                .padding(.bottom)
                .disabled(buttonDisabled)
                
                
                TextError(message: errorMessage)
            }
        }
        .disabled(isLoading)
        .onAppear {
            SessionStore.getUserName { name, error in
                if let error = error {
                    buttonDisabled = true
                    errorMessage = error.localizedDescription
                } else {
                    userName = name
                }
            }
        }
    }
    
    private func changeName() async {
        
        isNewUserNameError = newUserName.isEmptyOrWhitespace()
        
        if isNewUserNameError {
            errorMessage = ErrorMessages.emptySpace.localizedDescription
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await SessionStore.updateUser(newUserName: newUserName)
            
            errorMessage = "NAME CHANGED TO: \(SessionStore.getCurrentUser()?.displayName ?? "")"
            canSubmit = true
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView()
    }
}
