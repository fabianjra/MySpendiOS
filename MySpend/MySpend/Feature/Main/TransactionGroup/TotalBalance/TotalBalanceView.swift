//
//  TotalBalanceView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import SwiftUI

struct TotalBalanceView: View {
    
    @StateObject var viewModel = TotalBalanceViewModel()
    let transactions: [TransactionModel]
    
    var showDivider: Bool = true
    var showTotalBalance: Bool = true

    var body: some View {
        VStack {
            if showDivider {
                DividerView()
            }
            
            HStack {
                TextPlainLocalized(Localizable.Currency.incomes)
                Spacer()
                TextPlain(viewModel.totalIncomeFormatted,
                          color: Color.primaryTop,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            HStack {
                TextPlainLocalized(Localizable.Currency.expenses)
                Spacer()
                TextPlain(viewModel.totalExpensesFormatted,
                          color: Color.alert,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            if showTotalBalance {
                HStack {
                    TextPlainLocalized(Localizable.Currency.total_balance, size: .big)
                    Spacer()
                    TextPlain(viewModel.totalBalanceFormatted, size: .big)
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

#Preview(Previews.localeES) {
    VStack {
        TotalBalanceView(transactions: [])
        
        TotalBalanceView(transactions: [], showTotalBalance: false)
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    VStack {
        TotalBalanceView(transactions: [])
        
        TotalBalanceView(transactions: [], showTotalBalance: false)
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
