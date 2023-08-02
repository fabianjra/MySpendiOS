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
    
    //@State private var userEmail: String = ""
    //@State private var isUserEmailError: Bool = false
    @State private var buttonEnabled: Bool = false

    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var user = SessionStore.getCurrentUser()
    
    var body: some View {
        FormScrollContainer {
            
            //MARK: HEADER
            HStack {
                ButtonNavigationBack { dismiss() }
                    .padding(.leading)
                
                Spacer()
                
                TextTitleForm(title: "Validate account",
                              titleWeight: .regular,
                              titleSize: .bigXL)
                
                Spacer()
                
                ButtonNavigationBack {}
                    .hidden()
                    .padding(.trailing)
            }
            .padding(.bottom)
            
            
            //MARK: FIELDS
            VStack(spacing: Views.formSpacing) {
                
//                TextFieldEmail(text: $userEmail,
//                               isError: $isUserEmailError,
//                               errorMessage: $errorMessage)
//                .padding(.bottom)
//                .submitLabel(.send)
//                .onSubmit { sendEmail() }

                TextPlain(message: "Please follow the instructions that will be send to your email account.", aligment: .center)
                
                
                Button("Send email") {
                    sendEmail()
                }
                .buttonStyle(ButtonPrimaryStyle())
                .padding(.bottom)
                
                
                TextError(message: errorMessage)
            }
        }
        .onAppear {
            buttonEnabled = canSendEmail()
        }
    }
    
    private func sendEmail() {
        
        //isUserEmailError = userEmail.isEmptyOrWhitespace()
        
//        if isUserEmailError {
//            errorMessage = ErrorMessages.emptySpace.localizedDescription
//            return
//        }
        
        if canSendEmail() {
            SessionStore.sendEmailValidation(user: SessionStore.getCurrentUser()) { success, error in
                if success {
                    canSubmit = true
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func canSendEmail() -> Bool {
        if let user = self.user {
            if user.isEmailVerified {
                errorMessage = ErrorMessages.userIsVerified.localizedDescription
                return false
            } else {
                return true
            }
        } else {
           errorMessage = ErrorMessages.userNotLoggedIn.localizedDescription
            return false
       }
    }
}

struct ValidateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ValidateAccountView()
    }
}
