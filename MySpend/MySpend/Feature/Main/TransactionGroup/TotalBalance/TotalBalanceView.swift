//
//  TotalBalanceView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import SwiftUI

struct TotalBalanceView: View {
    
    @State var viewModel = TotalBalanceViewModel()
    let transactions: [TransactionModel]
    
    var showTotalBalance: Bool = true // Doesn't show in History.
    
    var body: some View {
        VStack {
            Divider()
                .frame(height: ConstantFrames.dividerHeight)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .overlay(Color.divider)
            
            HStack {
                Text(.transactionTypeIncomes)
                    .textStyle
                
                Spacer()
                
                Text(viewModel.totalIncomesFormatted)
                    .textStyle(color: .primaryTop,
                               family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            HStack {
                
                Text(.transactionTypeExpenses)
                
                Spacer()
                
                Text(viewModel.totalExpensesFormatted)
                    .textStyle(color: .alert,
                               family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            
            if showTotalBalance {
                HStack {
                    
                    Text(.transactionsTotalBalance)
                        .textStyle(size: .big)
                    
                    Spacer()
                    
                    Text(viewModel.totalBalanceFormatted)
                        .textStyle(size: .big)
                }
            }
        }
        .onAppear {
            viewModel.calculateTotalBalance(transactions)
        }
        .onChange(of: transactions) {
            viewModel.calculateTotalBalance(transactions)
        }
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State private var transactionsLoaded: [TransactionModel] = []
    
    var body: some View {
        TotalBalanceView(transactions: transactionsLoaded)
        .task {
            transactionsLoaded = await MockTransactionModel.fetchAll()
        }
    }
}

#Preview(Previews.localeES_CR) {
    ZStack {
        Color(.backgroundBottom)
        PreviewWrapper(.normal)
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    ZStack {
        Color(.backgroundBottom)
        PreviewWrapper(.normal)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
