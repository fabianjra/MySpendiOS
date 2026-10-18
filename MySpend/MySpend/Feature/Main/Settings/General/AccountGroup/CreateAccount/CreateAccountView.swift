//
//  AddModifyAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountManager.self) private var accountManager
    
    @State private var viewModel: AddModifyAccountViewModel
    
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    @FocusState private var isFocused: Bool
    
    @State private var toast = ToastViewModel()
    
    init(_ model: AccountModel? = nil) {
        _viewModel = State(wrappedValue: AddModifyAccountViewModel(model))
    }
    
    var body: some View {
        VStack {
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
                        Button("", systemImage: viewModel.account.icon) {
                            showIconsModal = true
                        }
                        .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        if !viewModel.account.icon.isEmptyOrWhitespace {
                            Button {
                                viewModel.account.icon = ""
                            } label: {
                                Text(.selectorClear)
                            }
                            .buttonStyle(.borderless) // Permite la accion sin mostrar el modal.
                        }
                    }
                    .formLabeledInputStyle
                    
                    
                    Toggle(isOn: $viewModel.isDefaultSelected) {
                        Text(.accountInputDefault)
                    }
                    .tint(.accentColor)

                } header: {
                    //Text()
                }
            }
            .padding(.top)
        }
        
        .navigationTitle(.accountCreateTitle)
        .navigationSubtitle(.accountCreateSubtitle)
        
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundGradient)
        
        .onAppear {
            isFocused = true
        }
        .onChange(of: selectedIcon) { _, newValue in
            viewModel.account.icon = newValue
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon)
        }
        //.presentationDetents([.large])
        
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    if viewModel.isNewAccount {
                        toast.response = await viewModel.create(with: accountManager)
                    } else {
                        toast.response = await viewModel.update(with: accountManager)
                    }
                }
            } label: {
                Text(.buttonSave)
                    .padding(.vertical, ConstantViews.paddingButtonVertical)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .padding(.horizontal)
            .buttonStyle(.glass)
            .padding(.bottom)
            .disabled(toast.show)
        }
        .toast(toast.response, isPresented: $toast.show)
        
        //TODO: Falta el toolbar
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .cancel) {
                    dismiss()
                }
            }
        }
        
//        FormContainer {
//            HeaderNavigator(title: viewModel.isNewAccount ? "New account" : "Modify account",
//                            titleWeight: .regular,
//                            titleSize: .title,
//                            subTitle: viewModel.isNewAccount ? "Enter the account details" : "Modify the account details",
//                            showLeadingAction: false,
//                            showTrailingAction: true)
//            .padding(.vertical)
//        }
//        .safeAreaInset(edge: .bottom) {
//            VStack {
//                
//                Button(action: {
//                    Task {
//                        if viewModel.isNewAccount {
//                            _ = await viewModel.create(with: accountManager)
//                        } else {
//                            _ = await viewModel.update(with: accountManager)
//                        }
//                    }
//                    
//                }, label: {
//                    TextPlain(viewModel.isNewAccount ? "Add" : "Modify")
//                        .padding(.vertical, ConstantViews.paddingButtonVertical)
//                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
//                })
//                .buttonStyle(.glass)
//                .padding(.bottom, viewModel.isNewAccount ? nil : .zero)
//                
//                
//                if viewModel.isNewAccount == false {
//                    Button("Delete") {
//                        viewModel.showAlert = true
//                    }
//                    .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold))
//                    .alert("Delete account", isPresented: $viewModel.showAlert) {
//                        
//                        Button("Delete", role: .destructive) {
//                            Task {
//                                _ = await viewModel.delete(with: accountManager)
//                            }
//                        }
//                        
//                        Button("Cancel", role: .cancel) { }
//                        
//                    } message: {
//                        Text("Want to delete this account? \n This action cannot be undone.")
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
    }
}


#Preview(Previews.localeES_CR) {
    
    @Previewable @State var previewAccountManager = AccountManager.shared
    
    NavigationStack {
        CreateAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
