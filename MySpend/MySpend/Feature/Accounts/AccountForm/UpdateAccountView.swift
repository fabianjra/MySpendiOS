//
//  UpdateAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/26.
//

import SwiftUI

struct UpdateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountManager.self) private var manager
    
    @Binding var account: AccountModel
    
    @State private var viewModel = AccountDetailEditViewModel()
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        VStack {
            AccountDetailEdit(account: $account, isDefaultSelected: $viewModel.isDefaultSelected)
        }
        .onAppear {
            viewModel.isDefaultSelected = account.id == manager.defaultAccount?.id
        }
        
        .navigationTitle(.accountUpdateTitle)
        .navigationSubtitle(.accountUpdateSubtitle)
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    Task {
                        toastResponse = await manager.update(account,
                                                                     isDefault: viewModel.isDefaultSelected)
                        if toastResponse?.type == .ok {
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
                .disabled(toastResponse != nil)
                
                Button(.alertOptionDelete, role: .destructive) {
                    viewModel.showAlert = true
                }
                .padding(.bottom)
            }
            
            .alert(.accountDelete(.zero), isPresented: $viewModel.showAlert) {
                Button(.alertOptionDelete, role: .destructive) {
                    Task {
                        toastResponse = await manager.delete(account)
                        
                        if toastResponse?.type == .ok {
                            dismiss()
                        }
                    }
                }
                
                Button(.alertOptionCancel, role: .cancel) { }
            } message: {
                Text(.accountDeleteMessage(.zero))
            }
            
        }
        .toast($toastResponse)
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .cancel) {
                    dismiss()
                }
            }
        }
        
        .background {
            Color.backgroundGradient
                .ignoresSafeArea(.container, edges: .all)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State var manager = AccountManager.shared
    @State var account = AccountModel()
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            List(manager.sortedAccounts) { account in
                Button(account.name) {
                    self.account = account
                    isPresented = true
                }
            }
        }
        .onChange(of: manager.sortedAccounts, initial: true) { _, accounts in
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
        .environment(manager)
    }
}

#Preview(Previews.localeES_CR) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
