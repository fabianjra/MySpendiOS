//
//  SelectAccountModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct SelectAccountView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(AccountManager.self) private var accountManager
    
    @Binding var selectedAccount: AccountModel
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            List {
                if accountManager.sortedAccounts.isEmpty {
                    
                    Text(.accountsEmpty)
                        .foregroundStyle(.secondary)
                    
                } else {
                    ForEach(accountManager.sortedAccounts) { item in
                        HStack {
                            let icon = item.icon.getIconFromSFSymbol
                            
                            if let image = icon {
                                image
                                    .font(.title3)
                            }
                            
                            Button(item.name) {
                                selectedAccount = item
                                dismiss()
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .animation(.default, value: accountManager.sortedAccounts)
            
            .navigationTitle(.accountsTitle)
            .navigationSubtitle(.accountsSelectSubtitle)
            
            .presentationDetents([.medium, .large], selection: $selectedDetent)
            .presentationBackground {
                if selectedDetent == .large {
                    Color.backgroundGradient
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, local: String = Previews.localeES_CR) {
        UserDefaultsManager.defaultAccountID = MockCDConstants.mainAccountID
        
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        self.local = local
    }
    
    var local: String
    
    @State var accountManager = AccountManager.shared
    @State var show: Bool = false
    @State var model = AccountModel()
    
    var body: some View {
        VStack {
            Button("Show") {
                show = true
            }
        }
        .sheet(isPresented: $show) {
            SelectAccountView(selectedAccount: $model)
        }
        .onAppear {
            show = true
        }
        .environment(accountManager)
        .environment(\.locale, .init(identifier: local))
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper(.normal, local: Previews.localeES_CR)
}

#Preview("Saturated \(Previews.localeEN)") {
    previewWrapper(.saturated, local: Previews.localeEN)
}

#Preview("Empty \(Previews.localeES)") {
    previewWrapper(.empty, local: Previews.localeES)
}
