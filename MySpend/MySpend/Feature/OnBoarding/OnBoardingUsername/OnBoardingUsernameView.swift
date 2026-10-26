//
//  OnBoardingView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import SwiftUI

struct OnBoardingUsernameView: View {
    
    @State private var viewModel = OnBoardingUsernameViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Form {
            Section {
                TextField(.personalInformationInputNamePlaceholder, text: $viewModel.userName)
                    .formInputStyle($viewModel.userName)
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .onSubmit {
                        viewModel.continueToNextStep(withName: true)
                    }
            } header: {
                //Text(.personalInformationInputNamePlaceholder)
            } footer: {
                Text(.onBoardingUsernameOptionalInputMessage)
            }
        }
        .onAppear { isFocused = true }
        
        .navigationTitle(.onBoardingUsernameTitle)
        .navigationSubtitle(.onBoardingUsernameEnterName)
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    Task {
                        viewModel.continueToNextStep(withName: true)
                    }
                } label: {
                    Text(.buttonContinue)
                        .padding(.vertical, ConstantViews.paddingButtonVertical)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                }
                .padding(.horizontal)
                .buttonStyle(.glass)
                .padding(.bottom)
                
                
                Button(.buttonSkip) {
                    viewModel.continueToNextStep(withName: false)
                }
                .foregroundStyle(.primary)
                .padding(.bottom)
            }
        }
        
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundGradient)
        
        .toast($viewModel.toastResponse)
    }
}

#Preview(Previews.localeES) {
    NavigationStack {
        OnBoardingUsernameView()
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    NavigationStack {
        OnBoardingUsernameView()
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
