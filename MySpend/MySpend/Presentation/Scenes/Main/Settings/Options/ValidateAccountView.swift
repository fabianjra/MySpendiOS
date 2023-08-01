//
//  ValidateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

struct ValidateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var userEmail: String = ""
    @State private var isUserEmailError: Bool = false

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
                
                TextTitleForm(title: "Validate account",
                              titleWeight: .regular,
                              titleSize: .bigXL,
                              subTitle: "Fill the email space",
                              subTitleWeight: .regular)
                
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
            .padding(.bottom)
            
            
            //MARK: FIELDS
            VStack(spacing: Views.formSpacing) {
                
                TextFieldEmail(text: $userEmail,
                               isError: $isUserEmailError,
                               errorMessage: $errorMessage)
                .padding(.bottom)
                .submitLabel(.send)
                .onSubmit { sendEmail() }
                
                
                Button("Send") {
                    sendEmail()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                
                
                TextError(message: errorMessage)
            }
        }
        .onAppear {
            if let user = user {
                if user.isEmailVerified {
                    errorMessage = ErrorMessages.userIsVerified.localizedDescription
                }
            } else {
               errorMessage = ErrorMessages.userNotLoggedIn.localizedDescription
           }
        }
    }
    
    private func sendEmail() {
        
        isUserEmailError = userEmail.isEmptyOrWhitespace()
        
        if isUserEmailError {
            errorMessage = ErrorMessages.emptySpace.localizedDescription
            return
        }
        
        canSubmit = true
    }
}

struct ValidateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ValidateAccountView()
    }
}
