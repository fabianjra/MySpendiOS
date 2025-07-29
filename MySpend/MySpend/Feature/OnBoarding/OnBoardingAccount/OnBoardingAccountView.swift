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
    
    private let table = Tables.onboarding
    private let tableButton = Tables.button
    
    var body: some View {
        LogContainer {
            
            HeaderNavigator(table: table, onlyTitle: true)
                .padding(.bottom)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                TextPlainLocalized(Localizations.onboarding.enter_account_name.key,
                                   table: table,
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
                    Text(Localizations.button.continu.key, tableName: tableButton)
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                
                Button {
                    Task {
                        await viewModel.finishOnBoarding(withName: false)
                    }
                } label: {
                    Text(Localizations.button.skip.key, tableName: tableButton)
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
