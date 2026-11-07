//
//  FilterTransactionsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/4/26.
//

import SwiftUI

struct FilterTransactionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AccountManager.self) private var accountManager
    @Environment(TransactionManager.self) private var transactionManager
    
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        VStack {
            List {
                if accountManager.sortedAccounts.isEmpty {
                    Text(.accountsEmpty)
                        .foregroundStyle(.secondary)
                    
                } else {
                    Section {
                        Button {
                            transactionManager.showOnlyFavorites.toggle()
                        } label: {
                            HStack {
                                Label(.filterByFavorite, systemImage: ConstantSystemImage.favoriteFill)
                                    .foregroundStyle(Color.primary)
                                
                                Spacer()
                                
                                Image(systemName: transactionManager.showOnlyFavorites ?
                                      ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle
                                )
                                .font(.title2)
                                .foregroundStyle(Color.accentColor)
                            }
                        }
                    } header: {
                        Text(.filterInclude)
                    }
                    
                    
                    Section {
                        ForEach(accountManager.sortedAccounts) { account in
                            
                            Button {
                                accountManager.toggleAccountToFilter(account)
                            } label: {
                                HStack {
                                    Label(account.name, systemImage: account.icon)
                                        .foregroundStyle(Color.primary)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    Image(systemName: accountManager.selectedAccountsToFilterByID.contains(account.id) ?
                                          ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle
                                    )
                                    .font(.title2)
                                    .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    } header: {
                        Text(.filterByAccount)
                    }
                }
            }
            .scrollContentBackground(.hidden)
                
            Button {
                accountManager.restoreSelectedAccountsToFilter()
                transactionManager.showOnlyFavorites = false
            } label: {
                Label(
                    .filterRestore,
                    systemImage: ConstantSystemImage.arrowCounterClockwise
                )
                .foregroundStyle(Color.primary)
            }
            .padding(.bottom, UtilsUI.isPad ? nil : .zero)
        }
        // MARK: NAVIGATION
        .navigationTitle(.filters)
        .navigationBarTitleDisplayMode(.inline)
            
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


private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        _transactionManager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
    }
    
    @State var transactionManager: TransactionManager
    @State var accountManager: AccountManager
    
    @State var show: Bool = false
    
    var body: some View {
        VStack {
            Button("Show") {
                show = true
            }
        }
        .sheet(isPresented: $show) {
            NavigationStack {
                FilterTransactionsView()
            }
        }
        .onAppear {
            show = true
        }
        .environment(transactionManager)
        .environment(accountManager)
    }
}

#Preview(Previews.localeES_CR) {
    PreviewWrapper(.normal)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    PreviewWrapper(.saturated)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview("Empty \(Previews.localeES)") {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES))
}
