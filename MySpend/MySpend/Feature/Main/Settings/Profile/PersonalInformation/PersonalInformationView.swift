//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct PersonalInformationView: View {

    @State private var viewModel = PersonalInformationViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        Form {
            Section {
                LabeledContent(.personalInformationInputName) {
                    TextField(.personalInformationInputNamePlaceholder, text: $viewModel.username)
                        .textContentType(.name)
                        .keyboardType(.alphabet)
                        .scrollDismissesKeyboard(.interactively)
                        .focused($isFocused)
                        .onSubmit {
                            isFocused = false
                        }
                }
            }
        }
        .scrollContentBackground(.hidden)
        //        .scrollDisabled(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(.personalInformationTitle)
        .navigationSubtitle(.personalInformationSubtitle)
        .background(Color.backgroundContentGradient)
        
        .onAppear {
            viewModel.onAppear()
        }
        
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.changeUserName()
            } label: {
                Text(.buttonSave)
                    .padding(.vertical, ConstantViews.paddingButtonVertical)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .padding(.horizontal)
            .buttonStyle(.glass)
            .padding(.bottom)
            .disabled(viewModel.showToast)
        }
        
        .toast(viewModel.responseToast, isPresented: $viewModel.showToast)
    }
}

#Preview(Previews.localeES) {
    NavigationStack {
        PersonalInformationView()
    }
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN_US) {
    NavigationStack {
        PersonalInformationView()
    }
    .environment(\.locale, .init(identifier: Previews.localeEN_US))
}
