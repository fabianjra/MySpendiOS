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
    
    @State private var account = AccountModel()
    @State private var isDefaultSelected = false
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        VStack {
            AccountDetailEdit(account: $account, isDefaultSelected: $isDefaultSelected)
        }
        
        .navigationTitle(.accountCreateTitle)
        .navigationSubtitle(.accountCreateSubtitle)
        
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    toastResponse = await manager.create(account, isDefault: isDefaultSelected)
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
        
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
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
        
        .toast($toastResponse)
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

#Preview(Previews.localeEN) {
    
    @Previewable @State var manager = AccountManager.shared
    
    NavigationStack {
        CreateAccountView()
    }
    .environment(manager)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
