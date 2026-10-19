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
    
    @State private var viewModel = AccountDetailEditViewModel()
    @State private var account = AccountModel()
    
    @State private var toast = ToastViewModel()
    
    var body: some View {
        VStack {
            AccountDetailEdit(account: $account, isDefaultSelected: $viewModel.isDefaultSelected)
        }
        
        .navigationTitle(.accountCreateTitle)
        .navigationSubtitle(.accountCreateSubtitle)
        
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    toast.response = await accountManager.create(account,
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


#Preview(Previews.localeES_CR) {
    
    @Previewable @State var previewAccountManager = AccountManager.shared
    
    NavigationStack {
        CreateAccountView()
    }
    .environment(previewAccountManager)
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
