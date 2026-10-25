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
    
    @State private var isDefaultSelected = false
    @State private var showAlert = false
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        VStack {
            AccountDetailEdit(account: $account, isDefaultSelected: $isDefaultSelected)
        }
        .onAppear {
            isDefaultSelected = account.id == manager.defaultAccount?.id
        }
        
        .navigationTitle(.accountUpdateTitle)
        .navigationSubtitle(.accountUpdateSubtitle)
        
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    Task {
                        toastResponse = await manager.update(account, isDefault: isDefaultSelected)
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
                    showAlert = true
                }
                .padding(.bottom)
            }
            
            .alert(.accountDelete(.zero), isPresented: $showAlert) {
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
        
        .toast($toastResponse)
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
            List(manager.sortedAccounts) { item in
                Button(item.name) {
                    self.account = item
                    isPresented = true
                }
            }
        }
        .onChange(of: manager.sortedAccounts, initial: true) { _, items in
            guard let firstItem = items.first else {
                return
            }
            
            account = firstItem
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
