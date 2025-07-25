//
//  OnBoardingAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingAccountView: View {
    
    @StateObject private var viewModel = OnBoardingAccountViewModel()
    @FocusState private var focusedField: OnBoardingAccountViewModel.Field?
    
    var body: some View {
        LogContainer {
            
            HeaderNavigator(onlyTitle: true)
                .padding(.bottom)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                TextPlain("Customize your main account name", family: .light, size: .big, aligment: .center, lineLimit: 2)
                
                TextFieldName(text: $viewModel.name,
                              iconLeading: nil,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit {
                    Task {
                        await viewModel.finishOnBoarding(withName: true)
                    }
                }
                
                
                Button("Continue") {
                    Task {
                        await viewModel.finishOnBoarding(withName: true)
                    }
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                
                Button("Do it later") {
                    Task {
                        await viewModel.finishOnBoarding(withName: false)
                    }
                }
                .buttonStyle(ButtonLinkStyle())
                .padding(.bottom)
                
                
                TextError(viewModel.errorMessage)
            }
            .modifier(AddKeyboardToolbar(focusedField: $focusedField))
        }
        .onAppear {
            focusedField = .name
        }
    }
}

#Preview {
    OnBoardingAccountView()
}
