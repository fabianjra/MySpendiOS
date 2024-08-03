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
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Validate account",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if userIsValidated {
                
                // MARK: PLAIN SCREEN
                userIsValidatedBody
                    .padding(.top)
                
            } else {
                
                // MARK: FIELDS
                sendEmailBody
            }
        }
        .disabled(isLoading)
        .onAppear {
            isUserValidated()
        }
    }
    
    private var userIsValidatedBody: some View {
        VStack {
            TextPlain(message: ConstantMessages.userIsValidated.localizedDescription,
                      family: .semibold,
                      size: .bigL,
                      aligment: .center)
            
            TextPlain(message: "No action necessary.",
                      family: .semibold,
                      size: .big,
                      aligment: .center)
            .padding(.bottom)
            
            Image(uiImage: ConstantEmojis.fest.textToImage(size: ConstantFrames.emojiSize))
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
        VStack(spacing: ConstantViews.formSpacing) {
            
            TextPlain(message: "Please follow the instructions that will be send to your email account.", aligment: .center)
            
            
            Button("Send email") {
                Task {
                    await sendEmail()
                }
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $isLoading))
            .padding(.bottom)
            .disabled(buttonDisabled)
            
            
            TextError(message: errorMessage)
        }
    }
    
    private func sendEmail() async {
        
        defer {
            isLoading = false
        }
        
        do {
            if isUserValidated() == false {
                try await SessionStore.sendEmailRegisteredUser()
                canSubmit = true
            }
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //@discardableResult: Avoid the warning Xcode gives us when you dont use the return value, because this function is called in the OnAppear View without using the result.
    @discardableResult
    private func isUserValidated() -> Bool {
        
        UtilsStore.getCurrentUser()?.reload()

        if let user = UtilsStore.getCurrentUser() {
            
            if user.isEmailVerified {
                userIsValidated = true
                buttonDisabled = true
                errorMessage = ConstantMessages.userIsValidated.localizedDescription
                return true
                
            } else {
                return false
            }
            
        } else {
            buttonDisabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return false
        }
    }
}

#Preview {
    ValidateAccountView()
}
