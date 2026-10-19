//
//  UpdateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/26.
//

import SwiftUI

struct UpdateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountManager.self) private var accountManager
    
    @Binding var account: AccountModel
    
    @State private var viewModel = AccountDetailEditViewModel()
    @State private var toast = ToastViewModel()
    
    var body: some View {
        VStack {
            AccountDetailEdit(account: $account, isDefaultSelected: $viewModel.isDefaultSelected)
        }
        .navigationTitle(.accountUpdateTitle)
        .navigationSubtitle(.accountUpdateSubtitle)
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    Task {
                        toast.response = await accountManager.update(account,
                                                                     isDefault: viewModel.isDefaultSelected)
                        if toast.response.type == .ok {
                            dismiss()
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
                
                Button(.alertOptionDelete, role: .destructive) {
                    viewModel.showAlert = true
                }
                .padding(.bottom)
            }
            
            .alert(.accountDelete(.zero), isPresented: $viewModel.showAlert) {
                Button(.alertOptionDelete, role: .destructive) {
                    Task {
                        toast.response = await accountManager.delete(account)
                        
                        if toast.response.type == .ok {
                            dismiss()
                        }
                    }
                }
                
                Button(.alertOptionCancel, role: .cancel) { }
            } message: {
                Text(.accountDeleteMessage(.zero))
            }
            
        }
        .toast(toast.response, isPresented: $toast.show)
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State var accountManager = AccountManager.shared
    @State var account = AccountModel()
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            List(accountManager.sortedAccounts) { account in
                Button(account.name) {
                    self.account = account
                    isPresented = true
                }
            }
        }
        .onChange(of: accountManager.sortedAccounts, initial: true) { _, accounts in
            guard let firstAccount = accounts.first else {
                return
            }
            
            account = firstAccount
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                UpdateAccountView(account: $account)
            }
        }
        .environment(accountManager)
    }
}

#Preview(Previews.localeES_CR) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
