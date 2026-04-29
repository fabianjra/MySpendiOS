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
                                Label(account.name, systemImage: account.icon)
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Spacer()
                                
                                Image(systemName: viewModel.selectedAccountsFilter.contains(account) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.selectIconInsideTextField,
                                           height: FrameSize.width.selectIconInsideTextField)
                                    .foregroundStyle(.primaryTop)
                            }
                            .contentShape(Rectangle())
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
                    //.listRowBackground(Color.listRowBackground)
                }
            }
            
            Button {
                viewModel.restoreFilterSelection()
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
