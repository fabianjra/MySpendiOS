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
    var addBottomSpacing: Bool = true

    var body: some View {
        VStack {
            if showDivider {
                DividerView()
            }
            
            HStack {
                TextPlain("Incomes")
                Spacer()
                TextPlain(viewModel.totalIncomeFormatted,
                          color: Color.primaryTop,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            HStack {
                TextPlain("Expenses")
                Spacer()
                TextPlain(viewModel.totalExpensesFormatted,
                          color: Color.alert,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            if showTotalBalance {
                HStack {
                    TextPlain("Total balance", size: .big)
                    Spacer()
                    TextPlain(viewModel.totalBalanceFormatted, size: .big)
                }
            }
        }
        .padding(.bottom, addBottomSpacing ? ConstantViews.paddingBottomResumeview : .zero)
        .onAppear {
            viewModel.calculateTotalBalance(transactions)
        }
        .onChange(of: transactions) {
            viewModel.calculateTotalBalance(transactions)
        }
    }
}

#Preview {
    VStack {
        TotalBalanceView(transactions: [])
        
        TotalBalanceView(transactions: [], showTotalBalance: false, addBottomSpacing: false)
    }
    .background(Color.backgroundBottom)
}
