//
//  FilterTransactionsView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/4/26.
//

import SwiftUI

struct FilterTransactionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack {
            List {
                if viewModel.allAccounts.isEmpty {
                    Text("No accounts yet")
                        .foregroundStyle(.secondary)
                } else {
                    Section {
                        ForEach(viewModel.allAccounts) { account in
                            
                            HStack {
                                Label(account.name, systemImage: "wallet.bifold.fill")
                                
                                Spacer()
                                
                                Image(systemName: viewModel.selectedAccountsFilter.contains(account) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.selectIconInsideTextField,
                                           height: FrameSize.width.selectIconInsideTextField)
                                    .foregroundStyle(.primaryTop)
                            }
                            .onTapGesture {
                                if viewModel.selectedAccountsFilter.contains(account) {
                                    viewModel.selectedAccountsFilter.remove(account)
                                } else {
                                    viewModel.selectedAccountsFilter.insert(account)
                                }
                            }
                        }
                    } header: {
                        TextPlain("By accounts")
                    }
                }
            }
            
            // Remove all selected accounts to show all accounts
            Button {
                viewModel.selectedAccountsFilter.removeAll()
            } label: {
                Label.clearFilter
                    .foregroundStyle(Color.alert, Color.alert)
            }
        }
        .font(.montserrat())
        //.foregroundColor(Color.listRowForeground)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundContentGradient)
        
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
    
    @StateObject private var viewModel = TransactionViewModel()
    
    var body: some View {
        FilterTransactionsView(viewModel: viewModel)
            .task {
                await viewModel.activateObservers()
            }
    }
}

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper(.normal)
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}
