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
                    Text("No accounts yet")
                        .foregroundStyle(.secondary)
                } else {
                    Section {
                        ForEach(allAccounts) { account in
                            
                            HStack {
                                Label(account.name, systemImage: account.icon)
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                                
                                Image(systemName: filters.selectedAccountsFilter.contains(account.id) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
                        TextPlain("By accounts")
                    }
                    //.listRowBackground(Color.listRowBackground)
                    
                    Section {
                            HStack {
                                Label("Only favorites", systemImage: ConstantSystemImage.favoriteFill)
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
                        TextPlain("Include")
                    }
                }
            }
            
            Button {
                filters.restoreFilter(allAccountsAvailable: allAccounts)
            } label: {
                Label.restoreFilters
                    .foregroundStyle(.textPrimaryForeground)
            }
        }
        .font(.montserrat())
        //.foregroundColor(Color.listRowForeground)
        .scrollContentBackground(.hidden)
//        .background(Color.backgroundContentGradient.opacity(0.2))
        
        // MARK: NAVIGATION
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .title) {
                TextPlain("Filters")
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

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}

