//
//  AddModifyAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI
 
struct AddModifyAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountManager.self) private var accountManager
    
    @State private var viewModel: AddModifyAccountViewModel
    @FocusState private var focusedField: AccountModel.Field?
    
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    init(_ model: AccountModel? = nil) {
        _viewModel = State(wrappedValue: AddModifyAccountViewModel(model))
    }
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: viewModel.isNewAccount ? "New account" : "Modify account",
                            titleWeight: .regular,
                            titleSize: .title,
                            subTitle: viewModel.isNewAccount ? "Enter the account details" : "Modify the account details",
                            showLeadingAction: false,
                            showTrailingAction: true)
            .padding(.vertical)
            
            
            // MARK: TEXTFIELDS
            
            VStack {
                TextFieldModelName(text: $viewModel.account.name,
                                   errorMessage: .constant(""))
                .focused($focusedField, equals: .name)
                .onSubmit {
                    Task {
                        if viewModel.isNewAccount {
                            _ = await viewModel.create(with: accountManager)
                        } else {
                            _ = await viewModel.update(with: accountManager)
                        }
                    }
                }
                
                Button("") {
                    showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: viewModel.account.icon, actionClear: {
                    viewModel.account.icon = ""
                }))
            }
            .padding(.bottom)
            
            //MARK: TOOGLE
            
            VStack {
                Toggle(isOn: $viewModel.isDefaultSelected) {
                    TextPlain("Default account:")
                }
                .tint(.accentColor)
                .padding(.horizontal)
                
                //TextError(viewModel.errorMessage)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                
                Button(action: {
                    Task {
                        if viewModel.isNewAccount {
                            _ = await viewModel.create(with: accountManager)
                        } else {
                            _ = await viewModel.update(with: accountManager)
                        }
                    }
                    
                }, label: {
                    TextPlain(viewModel.isNewAccount ? "Add" : "Modify")
                        .padding(.vertical, ConstantViews.paddingButtonVertical)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                })
                .buttonStyle(.glass)
                .padding(.bottom, viewModel.isNewAccount ? nil : .zero)
                
                
                if viewModel.isNewAccount == false {
                    Button("Delete") {
                        viewModel.showAlert = true
                    }
                    .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold))
                    .alert("Delete account", isPresented: $viewModel.showAlert) {
                        
                        Button("Delete", role: .destructive) {
                            Task {
                                _ = await viewModel.delete(with: accountManager)
                            }
                        }
                        
                        Button("Cancel", role: .cancel) { }
                        
                    } message: {
                        Text("Want to delete this account? \n This action cannot be undone.")
                    }
                }
            }
            .padding(.horizontal)
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon)
        }
        .onChange(of: selectedIcon) { _, newValue in
            viewModel.account.icon = newValue
        }
        .onAppear {
            focusedField = .name
        }
        .presentationDetents([.large])
    }
}


#Preview(Previews.localeES_CR) {
    
    @Previewable @State var previewAccountManager = AccountManager.shared
    
    VStack {
        AddModifyAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
