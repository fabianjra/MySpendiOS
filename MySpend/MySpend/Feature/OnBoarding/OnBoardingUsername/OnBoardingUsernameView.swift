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
        ScrollView {
            
            Text(.onBoardingUsernameStart)
                .textStyle
                .padding(.vertical)
            
            
            VStack(spacing: ConstantViews.formSpacing) {
                
                Text(.onBoardingUsernameEnterUsername)
                    .textStyle(family: .light, size: .big)
                
                
                TextFieldName(text: $viewModel.userName,
                              iconLeading: nil,
                              errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .userName)
                .onSubmit { viewModel.continueToNextStep(withName: true)}
                
                
                Button {
                    Task {
                        viewModel.continueToNextStep(withName: true)
                    }
                } label: {
                    Text(.buttonContinue)
                        .padding(.vertical, ConstantViews.paddingButtonTransaction)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                }
                .buttonStyle(.glass)
                
                
                Button {
                    viewModel.continueToNextStep(withName: false)
                } label: {
                    Text(.onBoardingSkip)
                        .textStyle
                }
                
                
                TextError(viewModel.errorMessage)
            }
        }
        .padding(.horizontal)
        .scrollDisabled(false)
        .background(Color.backgroundContentGradient)
        .onAppear { focusedField = .userName }
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
