//
//  OnBoardingView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingUsernameView: View {
    
    @StateObject private var viewModel = OnBoardingUsernameViewModel()
    @FocusState private var focusedField: OnBoardingUsernameViewModel.Field?
    
    var body: some View {
        LogContainer {
            
            // MARK: HEADER
            HeaderNavigator(table: LocalizableTable.onboarding, subTitle: Localizable.Onboarding.title.key, onlyTitle: true)
                .padding(.bottom)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextPlainLocalized(Localizable.Onboarding.enter_name,
                                   family: .light,
                                   size: .big)
                
                
                TextFieldName(text: $viewModel.userName,
                              iconLeading: nil,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .userName)
                .onSubmit { viewModel.continueToNextStep(withName: true)}
                
                
                Button {
                    viewModel.continueToNextStep(withName: true)
                } label: {
                    TextPlainLocalized(Localizable.Button.continu)
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                Button {
                    viewModel.continueToNextStep(withName: false)
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
            focusedField = .userName
        }
    }
}

#Preview(Previews.localeES) {
    OnBoardingUsernameView()
        .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    OnBoardingUsernameView()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
