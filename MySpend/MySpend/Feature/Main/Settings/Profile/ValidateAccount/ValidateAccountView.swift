//
//  ValidateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import SwiftUI

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
        //.disabled(viewModel.isLoading)
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    private var userIsValidatedBody: some View {
        VStack {
            
            LinearGradient(colors: Color.primaryGradiant,
                           startPoint: .leading,
                           endPoint: .trailing)
            .mask {
                Image.checkmarkCircleFill
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: FrameSize.width.checkMarkIcon,
                   height: FrameSize.height.checkMarkIcon,
                   alignment: .center)
            .padding(.bottom)

            TextPlain(Errors.userIsValidated.localizedDescription,
                      family: .semibold,
                      size: .bigL,
                      aligment: .center)
            
            TextPlain("No action necessary.",
                      family: .semibold,
                      size: .big,
                      aligment: .center)
            .padding(.bottom)
            
            Button("Go back") {
                dismiss()
            }
            //.buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
            .padding(.top)
        }
        .padding(.top)
    }
    
    private var sendEmailBody: some View {
        VStack(spacing: ConstantViews.formSpacing) {
            
            TextPlain("Send the information to your email account and follow next steps.",
                      aligment: .center,
                      lineLimit: ConstantViews.messageMaxLines)
            
            
            Button("Send email") {
                Task {
                    await viewModel.sendEmail()
                }
            }
            //.buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
            .disabled(viewModel.disabled)
            
            
            TextError(viewModel.errorMessage)
        }
    }
}

#Preview {
    ValidateAccountView()
}
