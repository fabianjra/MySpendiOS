//
//  TotalBalanceView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import SwiftUI

struct TotalBalanceView: View {
    
    let transactions: [TransactionModel]
    
    var body: some View {
        VStack {
//            Divider()
//                .frame(height: ConstantFrames.dividerHeight)
//                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
//                .overlay(Color.secondary)
            
            let totals = transactions.calculateTotals()
            
            HStack {
                Text(.categoryTypeIncomes)
                    .fontDesign(.rounded)
                
                Spacer()
                
                Text(totals.incomes.amountToString)
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
                
                Text(totals.expenses.amountToString)
                    .foregroundStyle(.alert)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .lineLimit(1)
            }
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
