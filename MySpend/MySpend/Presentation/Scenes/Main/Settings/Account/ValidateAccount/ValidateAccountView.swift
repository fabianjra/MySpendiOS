//
//  ValidateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI
import Firebase

struct ValidateAccountView: View {
    
    @StateObject var viewModel = ValidateAccountViewModel()
    
    var body: some View {
        FormContainer {
            
            // MARK: HEADER
            HeaderNavigator(title: "Validate account",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if viewModel.userIsValidated {
                
                // MARK: PLAIN SCREEN
                userIsValidatedBody
                    .padding(.top)
                
            } else {
                
                // MARK: FIELDS
                sendEmailBody
            }
        }
        .disabled(viewModel.isLoading)
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
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
            .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
            .padding(.top)
        }
        .padding(.top)
    }
    
    private var sendEmailBody: some View {
        VStack(spacing: ConstantViews.formSpacing) {
            
            TextPlain(message: "Send the information to your email account and follow next steps.", aligment: .center)
            
            
            Button("Send email") {
                Task {
                    await viewModel.sendEmail()
                }
            }
            .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
            .disabled(viewModel.disabled)
            
            
            TextError(message: viewModel.errorMessage)
        }
    }
}

#Preview {
    ValidateAccountView()
}
