//
//  ChangeNameView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/23.
//

import SwiftUI

struct PersonalInformationView: View {

    @State private var viewModel = PersonalInformationViewModel()
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        VStack {
            Form {
                Section {
                    LabeledContent(.inputName) {
                        TextField(.personalInformationInputNamePlaceholder, text: $viewModel.username)
                            .formInputStyle($viewModel.username)
                            .textContentType(.name)
                            .keyboardType(.alphabet)
                    }
                    .formLabeledInputStyle
                    
                    LabeledContent(.inputEmail) {
                        TextField(.personalInformationInputEmailPlaceholder, text: $viewModel.email)
                            .formInputStyle($viewModel.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                    }
                    .formLabeledInputStyle
                    
                    LabeledContent(.inputPhone) {
                        TextField(.personalInformationInputPhonePlaceholder, text: $viewModel.phoneNumber)
                            .formInputStyle($viewModel.phoneNumber)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                    }
                    .formLabeledInputStyle
                }
            }
        }
        .navigationTitle(.personalInformationTitle)
        .navigationSubtitle(.personalInformationSubtitle)
        
        .scrollContentBackground(.hidden)
        .background(Color.backgroundGradient)
        
        .onAppear {
            viewModel.loadData()
        }
        
        .safeAreaInset(edge: .bottom) {
            Button {
                toastResponse = viewModel.changeUserName()
            } label: {
                Text(.buttonSave)
                    .padding(.vertical, ConstantViews.paddingButtonVertical)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .padding(.horizontal)
            .buttonStyle(.glass)
            .padding(.bottom)
            .disabled(toastResponse != nil)
        }
        .background {
            Color.backgroundGradient
                .ignoresSafeArea(.container, edges: .all)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        
        .toast($toastResponse)
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
