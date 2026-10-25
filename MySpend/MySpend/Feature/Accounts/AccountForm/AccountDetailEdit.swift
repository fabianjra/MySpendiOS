//
//  AccountDetailEdit.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/10/26.
//

import SwiftUI

struct AccountDetailEdit: View {
    
    // PARAMETRIZADOS
    @Binding var account: AccountModel
    @Binding var isDefaultSelected: Bool

    // LOCALES
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Form {
            Section {
                
                LabeledContent(.inputName) {
                    TextField(.accountInputNamePlaceHolder, text: $account.name)
                        .formInputStyle($account.name)
                        .textContentType(.creditCardName)
                        .keyboardType(.alphabet)
                        .focused($isFocused)
                }
                .formLabeledInputStyle
                
                
                LabeledContent(.inputIcon) {
                    Button {
                        showIconsModal = true
                    } label: {
                        if account.icon.isEmptyOrWhitespace {
                            Text(.inputIconPlaceHolder)
                                .foregroundStyle(Color(uiColor: .placeholderText))
                            
                        } else {
                            Image(systemName: account.icon)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    
                    Spacer()
                    
                    if !account.icon.isEmptyOrWhitespace {
                        Button {
                            account.icon = ""
                        } label: {
                            Text(.selectorClear)
                        }
                        .buttonStyle(.borderless) // Permite la accion de borrar el icono sin irse a la accion de mostrar modal.
                    }
                }
                .formLabeledInputStyle
                
                
                Toggle(isOn: $isDefaultSelected) {
                    Text(.accountInputDefault)
                }
                .tint(.accentColor)

            } footer: {
                Text(.inputNameRequired)
            }
        }
        .scrollDisabled(true)
        .padding(.top)
        .scrollContentBackground(.hidden)
        
        .onAppear {
            isFocused = true
        }
        .onChange(of: selectedIcon) { _, newValue in
            account.icon = newValue
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon)
        }
    }
}

#Preview(Previews.localeES_CR) {
    
    @Previewable @State var account = AccountModel()
    @Previewable @State var isDefaultSelected = false
    
    AccountDetailEdit(account: $account, isDefaultSelected: $isDefaultSelected)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}


#Preview(Previews.localeEN) {
    
    @Previewable @State var account = AccountModel()
    @Previewable @State var isDefaultSelected = false
    
    AccountDetailEdit(account: $account, isDefaultSelected: $isDefaultSelected)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
