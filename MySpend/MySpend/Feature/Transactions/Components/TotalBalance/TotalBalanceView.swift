//
//  TotalBalanceView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import SwiftUI

struct TotalBalanceView: View {
    
    @State private var viewModel = TotalBalanceViewModel()
    let transactions: [TransactionModel]
    
    var body: some View {
        VStack {
            Divider()
                .frame(height: ConstantFrames.dividerHeight)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .overlay(Color.divider)
            
            HStack {
                Text(.categoryTypeIncomes)
                    .fontDesign(.rounded)
                
                Spacer()
                
                Text(viewModel.totalIncomesFormatted)
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .lineLimit(1)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            HStack {
                
                Text(.categoryTypeExpenses)
                    .fontDesign(.rounded)
                
                Spacer()
                
                Text(viewModel.totalExpensesFormatted)
                    .foregroundStyle(.alert)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .lineLimit(1)
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


#Preview(Previews.localeES_CR) {
    
    @Previewable var mock = MockDataType.normal
    @Previewable @State var transactionsLoaded: [TransactionModel] = []
    
    TotalBalanceView(transactions: transactionsLoaded)
        .task {
            transactionsLoaded = await MockTransactionUtils.fetchAll(mock.viewContext)
        }
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}


#Preview(Previews.localeEN) {
    
    @Previewable var mock = MockDataType.saturated
    @Previewable @State var transactionsLoaded: [TransactionModel] = []
    
    TotalBalanceView(transactions: transactionsLoaded)
        .task {
            transactionsLoaded = await MockTransactionUtils.fetchAll(mock.viewContext)
        }
        .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview(Previews.localeEN) {
    
    @Previewable var mock = MockDataType.empty
    @Previewable @State var transactionsLoaded: [TransactionModel] = []
    
    TotalBalanceView(transactions: transactionsLoaded)
        .task {
            transactionsLoaded = await MockTransactionUtils.fetchAll(mock.viewContext)
        }
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
