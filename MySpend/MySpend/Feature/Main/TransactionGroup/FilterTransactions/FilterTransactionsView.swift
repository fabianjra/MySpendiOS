//
//  FilterTransactionsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/4/26.
//

import SwiftUI

struct FilterTransactionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var allAccounts: [AccountModel]
    private let filters = FilterCenter.shared
    
    var body: some View {
        VStack {
            List {
                if allAccounts.isEmpty {
                    Text(.accountsEmpty)
                        .textStyle(color: .secondary)
                    
                } else {
                    Section {
                        ForEach(allAccounts) { account in
                            
                            HStack {
                                Label(account.name, systemImage: account.icon)
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                                
                                Image(systemName: filters.selectedAccountsFilter.contains(account.id) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.primaryTop)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                filters.toggleAccount(account)
                            }
                        }
                    } header: {
                        Text(.filterByAccount)
                            .textStyle
                    }
                    //.listRowBackground(Color.listRowBackground)
                    
                    Section {
                            HStack {
                                Label(.filterByFavorite, systemImage: ConstantSystemImage.favoriteFill)
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                                
                                Image(systemName: filters.showOnlyFavorites ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.primaryTop)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                filters.showOnlyFavorites.toggle()
                            }
                    } header: {
                        Text(.filterInclude)
                            .textStyle
                    }
                }
            }
            
            Button {
                filters.restoreFilter(allAccountsAvailable: allAccounts)
            } label: {
                Label(.filterRestore, systemImage: ConstantSystemImage.arrowCounterClockwise)
                    .foregroundStyle(.textPrimaryForeground)
            }
        }
        //.foregroundColor(Color.listRowForeground)
        .scrollContentBackground(.hidden)
//        .background(Color.backgroundContentGradient.opacity(0.2))
        
        // MARK: NAVIGATION
        //.navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(.filters)
                    .textStyle
            }
            
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
    
    @State private var accountsLoaded: [AccountModel] = []
    
    var body: some View {
        FilterTransactionsView(allAccounts: $accountsLoaded)
            .task {
                accountsLoaded = await MockAccountModel.fetchAll()
            }
    }
}

#Preview(Previews.localeES_CR) {
    NavigationStack {
        previewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}

#Preview(Previews.localeEN) {
    NavigationStack {
        previewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeEN))
    }
}

#Preview("Empty \(Previews.localeES)") {
    NavigationStack {
        previewWrapper()
            .environment(\.locale, .init(identifier: Previews.localeES))
    }
}
