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
                TextPlainLocalized(Localizable.Onboarding.enter_account_name,
                                   family: .light,
                                   size: .big,
                                   aligment: .center,
                                   lineLimit: 2)
                
                TextFieldName(text: $viewModel.name,
                              iconLeading: nil,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit {
                    Task {
                        await viewModel.finishOnBoarding(withName: true)
                    }
                }
                
                
                Button {
                    Task {
                        await viewModel.finishOnBoarding(withName: true)
                    }
                } label: {
                    TextPlainLocalized(Localizable.Button.continu)
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                
                Button {
                    Task {
                        await viewModel.finishOnBoarding(withName: false)
                    }
                } label: {
                    TextPlainLocalized(Localizable.Button.skip)
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

#Preview(Previews.localeES) {
    OnBoardingAccountView()
        .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    OnBoardingAccountView()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
