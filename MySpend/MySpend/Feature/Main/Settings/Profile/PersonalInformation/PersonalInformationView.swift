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
            VStack(spacing: ConstantViews.formSpacing) {
                
                TextFieldName(placeHolder: "Username",
                              text: $viewModel.username,
                              iconLeading: Image.personFill,
                              errorMessage: $viewModel.errorMessage)
                .padding(.bottom)
                .focused($isFocused)
                .onSubmit { viewModel.changeUserName() }
                
                
                Text(viewModel.errorMessage)
                    .textErrorStyle
                
                Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(.personalInformationTitle)
        .navigationSubtitle(.personalInformationSubtitle)
        .background(Color.backgroundContentGradient)
        
        .onAppear {
            isFocused = true
            viewModel.onAppear()
        }
        
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                viewModel.changeUserName()
            }, label: {
                Text(.buttonSave)
                    .padding(.vertical, ConstantViews.paddingButtonVertical)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            })
            .padding(.horizontal)
            .buttonStyle(.glass)
            .padding(.bottom)
        }
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
