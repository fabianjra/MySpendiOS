//
//  TotalBalanceView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import SwiftUI

struct TotalBalanceView: View {
    
    @StateObject var viewModel = TotalBalanceViewModel()
    @Binding var transactions: [TransactionModel]
    
    var showTotalBalance: Bool = true
    var addBottomSpacing: Bool = true

    var body: some View {
        VStack {
            DividerView()
            
            HStack {
                TextPlain(message: "Incomes")
                Spacer()
                TextPlain(message: viewModel.totalIncomeFormatted,
                          color: Color.primaryLeading,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            HStack {
                TextPlain(message: "Expenses")
                Spacer()
                TextPlain(message: viewModel.totalExpensesFormatted,
                          color: Color.alert,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            if showTotalBalance {
                HStack {
                    TextPlain(message: "Total balance", size: .big)
                    Spacer()
                    TextPlain(message: viewModel.totalBalanceFormatted, size: .big)
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
        TotalBalanceView(transactions: .constant([]))
        
        TotalBalanceView(transactions: .constant([]), showTotalBalance: false, addBottomSpacing: false)
    }
    .background(Color.backgroundBottom)
}
