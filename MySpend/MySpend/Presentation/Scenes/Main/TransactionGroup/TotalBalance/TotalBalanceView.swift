//
//  TotalBalanceView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import SwiftUI

struct TotalBalanceView: View {
    
    var totalIncomes = ""
    var totalExpenses = ""
    var totalBalance = ""
    
    var showTotalBalance: Bool = true
    var addBottomSpacing: Bool = true
    
    var body: some View {
        VStack {
            DividerView()
            
            HStack {
                TextPlain(message: "Incomes")
                Spacer()
                TextPlain(message: totalIncomes,
                          color: Color.primaryLeading,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            HStack {
                TextPlain(message: "Expenses")
                Spacer()
                TextPlain(message: totalExpenses,
                          color: Color.alert,
                          family: .semibold)
            }
            .padding(.bottom, ConstantViews.minimumSpacing)
            
            if showTotalBalance {
                HStack {
                    TextPlain(message: "Total balance", size: .big)
                    Spacer()
                    TextPlain(message: totalBalance, size: .big)
                }
            }
        }
        .padding(.bottom, addBottomSpacing ? ConstantViews.paddingBottomResumeview : .zero)
    }
}

#Preview {
    VStack {
        TotalBalanceView(totalIncomes: "$300", totalExpenses: "$100", totalBalance: "$200")
        
        TotalBalanceView(totalIncomes: "$10", totalExpenses: "$5", totalBalance: "$5", showTotalBalance: false, addBottomSpacing: false)
    }
    .background(Color.backgroundBottom)
}
