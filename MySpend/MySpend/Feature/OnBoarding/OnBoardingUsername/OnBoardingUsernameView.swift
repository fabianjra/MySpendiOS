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
    
    private let table = Tables.onboarding
    
    var body: some View {
        LogContainer {
            
            // MARK: HEADER
            HeaderNavigator(table: table, subTitle: LocalKey.Onboarding.title.key, onlyTitle: true)
                .padding(.bottom)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextPlainLocalized2(LocalKey.Onboarding.enter_name,
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
                    TextPlainLocalized2(LocalKey.Button.continu)
                }
                .buttonStyle(ButtonPrimaryStyle())
                
                Button {
                    viewModel.continueToNextStep(withName: false)
                } label: {
                    TextPlainLocalized2(LocalKey.Button.skip)
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
