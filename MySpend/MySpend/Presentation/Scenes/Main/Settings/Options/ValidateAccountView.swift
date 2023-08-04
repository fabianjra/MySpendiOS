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
    
    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var userIsValidated: Bool = false
    @State private var buttonDisabled: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Validate account",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            // MARK: PLAIN SCREEN
            if !userIsValidated {
                
                userIsValidatedBody
                    .padding(.top)
                
            } else {
                
                // MARK: FIELDS
                sendEmailBody
            }
        }
        .disabled(isLoading)
        .onAppear {
            //the answer is opposite, becuase disabled is opposite to can send email.
            //eg: can send email?: YES - So button is NOT disabled (opposite).
            buttonDisabled = !canSendEmail()
        }
    }
    
    private var userIsValidatedBody: some View {
        VStack {
            TextPlain(message: ErrorMessages.userIsValidated.localizedDescription,
                      family: .semibold,
                      size: .bigXL,
                      aligment: .center)
            
            TextPlain(message: "No action necessary.",
                      family: .semibold,
                      size: .bigL,
                      aligment: .center)
            .padding(.bottom)
            
            Image(uiImage: "🥳".textToImage(size: 60))
                .padding(.bottom)
            
            Button("Go back") {
                dismiss()
            }
            .buttonStyle(ButtonPrimaryStyle())
            .padding(.top)
        }
        .padding(.top)
    }
    
    private var sendEmailBody: some View {
        VStack(spacing: Views.formSpacing) {
            
            TextPlain(message: "Please follow the instructions that will be send to your email account.", aligment: .center)
            
            
            Button("Send email") {
                sendEmail()
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
            .padding(.bottom)
            .disabled(buttonDisabled)
            
            
            TextError(message: errorMessage)
        }
    }
    
    private func sendEmail() {
        if canSendEmail() {
            
            isLoading = true
            
            SessionStore.sendEmailValidation() { success, error in
                defer {
                    isLoading = false
                }
                
                if success {
                    canSubmit = true
                    errorMessage = "EMAIL SENT!"
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func canSendEmail() -> Bool {
        if let user = SessionStore.getCurrentUser() {
            if user.isEmailVerified {
                userIsValidated = true
                errorMessage = ErrorMessages.userIsValidated.localizedDescription
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
