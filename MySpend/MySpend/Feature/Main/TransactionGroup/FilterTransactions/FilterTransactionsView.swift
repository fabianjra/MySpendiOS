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
    
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        VStack {
            List {
                if accountManager.sortedAccounts.isEmpty {
                    Text(.accountsEmpty)
                        .foregroundStyle(.secondary)
                    
                } else {
                    Section {
                        ForEach(accountManager.sortedAccounts) { account in
                            
                            Button {
                                accountManager.toggleFilter(account)
                            } label: {
                                HStack {
                                    Label(account.name, systemImage: account.icon)
                                        .foregroundStyle(Color.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: accountManager.filteredAccounts.contains(account.id) ?
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
                    
                    Section {
                        
                        Button {
                            accountManager.showOnlyFavorites.toggle()
                        } label: {
                            HStack {
                                Label(.filterByFavorite, systemImage: ConstantSystemImage.favoriteFill)
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                                
                                Image(systemName: accountManager.showOnlyFavorites ?
                                      ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle
                                )
                                .font(.title2)
                                .foregroundStyle(Color.accentColor)
                            }
                        }
                    } header: {
                        Text(.filterInclude)
                    }
                }
            }
            .scrollContentBackground(.hidden)
                
            Button {
                accountManager.restoreFilter()
            } label: {
                Label(
                    .filterRestore,
                    systemImage: ConstantSystemImage.arrowCounterClockwise
                )
                .foregroundStyle(.textPrimaryForeground)
            }
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


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State var previewFilter = AccountManager.shared
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
        .environment(previewFilter)
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper(.normal)
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    previewWrapper(.normal)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview("Empty \(Previews.localeES)") {
    previewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES))
}
