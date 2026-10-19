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
    
    var account: AccountModel
    
    @State private var viewModel = AccountDetailEditViewModel()
    @State private var toast = ToastViewModel()
    
    var body: some View {
        Text(account.name)
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State var accountManager = AccountManager.shared
    @State var account: AccountModel?
    
    var body: some View {
        VStack {
            List(accountManager.sortedAccounts) { account in
                Button(account.name) {
                    self.account = account
                }
            }
        }
        .onChange(of: accountManager.sortedAccounts, initial: true) { _, accounts in
            guard account == nil, let firstAccount = accounts.first else {
                return
            }
            
            account = firstAccount
        }
        
        .sheet(item: $account) { account in
            NavigationStack {
                UpdateAccountView(account: account)
            }
        }
        .environment(accountManager)
    }
}

#Preview(Previews.localeES_CR) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
