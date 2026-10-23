//
//  AddModifyAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountManager.self) private var manager
    
    @State private var viewModel = AccountDetailEditViewModel()
    @State private var account = AccountModel()
    
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        VStack {
            AccountDetailEdit(account: $account, isDefaultSelected: $viewModel.isDefaultSelected)
        }
        
        .navigationTitle(.accountCreateTitle)
        .navigationSubtitle(.accountCreateSubtitle)
        
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    toastResponse = await manager.create(account,
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


#Preview(Previews.localeES_CR) {
    
    @Previewable @State var manager = AccountManager.shared
    
    NavigationStack {
        CreateAccountView()
    }
    .environment(manager)
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
