//
//  ValidateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

struct ValidateAccountView: View {
    
    @StateObject var validateAccountVM = ValidateAccountViewModel()
    
    var body: some View {
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Validate account",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if validateAccountVM.model.userIsValidated {
                
                // MARK: PLAIN SCREEN
                userIsValidatedBody
                    .padding(.top)
                
            } else {
                
                // MARK: FIELDS
                sendEmailBody
            }
        }
        .disabled(validateAccountVM.isLoading)
        .onAppear {
            validateAccountVM.isUserValidated()
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
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
            
            TextPlain(message: "Follow next steps in your email account.", aligment: .center)
            
            
            Button("Send email") {
                Task {
                    await validateAccountVM.sendEmail()
                }
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $validateAccountVM.isLoading))
            .padding(.bottom)
            .disabled(validateAccountVM.model.disabled)
            
            
            TextError(message: validateAccountVM.model.errorMessage)
        }
    }
}

#Preview {
    ValidateAccountView()
}
