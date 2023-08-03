//
//  ValidateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

struct ValidateAccountView: View {
    
    @State private var buttonDisabled: Bool = false
    
    @State private var canSubmit: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        FormScrollContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Validate account",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            
            // MARK: FIELDS
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
        .onAppear {
            //the answer is opposite, becuase disabled is opposite to can send email.
            //eg: can send email?: YES - So button is NOT disabled (opposite).
            buttonDisabled = !canSendEmail()
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
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func canSendEmail() -> Bool {
        if let user = SessionStore.getCurrentUser() {
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
