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
    
    @StateObject private var viewModel: AddModifyAccountViewModel
    @FocusState private var focusedField: AccountModel.Field?
    
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    init(_ model: AccountModel? = nil) {
        _viewModel = StateObject(wrappedValue: AddModifyAccountViewModel(model))
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
                                   errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process(viewModel.isNewAccount ? .add : .modify) }
                
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
                
                TextError(viewModel.errorMessage)
                    .padding(.vertical)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button(action: {
                    process(viewModel.isNewAccount ? .add : .modify)
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
                        Button("Delete", role: .destructive) { process(.delete) }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this account? \n This action cannot be undone.")
                    }
                }
            }
            .padding(.horizontal)
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon, showModal: $showIconsModal)
        }
        .onChange(of: selectedIcon) { _, newValue in
            viewModel.account.icon = newValue
        }
        .onAppear {
            focusedField = .name
        }
        .presentationDetents([.large])
    }
    
    private func process(_ processType: ProcessType) {
        Task {
            let result: ResponseModel
            
            switch processType {
            case .add:
                result = await viewModel.addNew(accountManager: accountManager)
            case .modify:
                result = await viewModel.modify()
            case .delete:
                result = await viewModel.delete()
            }
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
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
