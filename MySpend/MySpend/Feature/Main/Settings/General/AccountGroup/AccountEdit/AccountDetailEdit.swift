//
//  AccountDetailEdit.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/10/26.
//

import SwiftUI

struct AccountDetailEdit: View {
    
    @Bindable var viewModel: AccountDetailEditViewModel
    
    @State private var showIconsModal = false
    @State private var selectedIcon = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Form {
            Section {
                
                LabeledContent(.accountInputName) {
                    TextField(.accountInputNamePlaceHolder, text: $viewModel.account.name)
                        .formInputStyle($viewModel.account.name)
                        .textContentType(.creditCardName)
                        .keyboardType(.alphabet)
                        .focused($isFocused)
                }
                .formLabeledInputStyle
                
                
                LabeledContent(.accountInputIcon) {
                    Button(viewModel.account.icon, systemImage: viewModel.account.icon) {
                        showIconsModal = true
                    }
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    if !viewModel.account.icon.isEmptyOrWhitespace {
                        Button {
                            viewModel.account.icon = ""
                        } label: {
                            Text(.selectorClear)
                        }
                        .buttonStyle(.borderless) // Permite la accion de borrar el icono sin irse a la accion de mostrar modal.
                    }
                }
                .formLabeledInputStyle
                
                
                Toggle(isOn: $viewModel.isDefaultSelected) {
                    Text(.accountInputDefault)
                }
                .tint(.accentColor)

            } header: {
                Text(.accountListTitle)
            }
        }
        .scrollDisabled(true)
        .padding(.top)
        
        .onAppear {
            isFocused = true
        }
        .onChange(of: selectedIcon) { _, newValue in
            viewModel.account.icon = newValue
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon)
        }
        
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var viewModel = AccountDetailEditViewModel()
    @Previewable @State var isPresented: Bool = false
    
    AccountDetailEdit(viewModel: viewModel)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}


#Preview(Previews.localeEN) {
    
    @Previewable @State var viewModel = AccountDetailEditViewModel()
    @Previewable @State var isPresented: Bool = false
    
    AccountDetailEdit(viewModel: viewModel)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
