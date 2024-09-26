//
//  HistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if viewModel.transactions.isEmpty {
                Spacer()
                TextPlain(message: "No transactions",
                          family: .semibold,
                          size: .bigXL,
                          aligment: .center)
                .padding(.vertical)
                Spacer()
            } else {
                VStack {
                    Picker("Transaction type", selection: $viewModel.model.historyFormat) {
                        ForEach(HistoryFormatEnum.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    //.colorMultiply(.primaryLeading)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.transactions) { item in
                            HStack {
                                TextPlain(message: item.categoryId.description,
                                          lineLimit: ConstantViews.transactionsMaxLines)
                                
                                Spacer()
                                
                                TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol(),
                                          lineLimit: ConstantViews.transactionsMaxLines)
                            }
                            .padding(.vertical, ConstantViews.textResumeSpacing)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            
            
            TextError(message: viewModel.errorMessage)
                .padding(.bottom)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
        }
    }
}

#Preview("With Content") {
    VStack {
        let transaction1 = TransactionModel(amount: 56000,
                                            date: "25/05/1990",
                                            categoryId: "Diario",
                                            detail: "Nota",
                                            type: .expense)
        let transaction2 = TransactionModel(amount: 3000.9,
                                            date: "25/05/2024",
                                            categoryId: "Gastos mensuales del mes abc abc abcdefthijklmnbrto adfsafsdf a saf",
                                            detail: "Nota",
                                            type: .expense)
        let transaction3 = TransactionModel(amount: 100,
                                            date: "01/12/2003",
                                            categoryId: "No category",
                                            detail: "Nota",
                                            type: .expense)
        let transaction4 = TransactionModel(amount: 301928564721.328,
                                            date: "01/05/2023",
                                            categoryId: "Gastos mensuales del mes abc abc abcdefthijklmnbrto adfsafsdf a saf",
                                            detail: "Nota",
                                            type: .expense)
        let transaction5 = TransactionModel(amount: 3000.1,
                                            date: "25/05/2024",
                                            categoryId: "Gastos mensuales",
                                            detail: "Nota",
                                            type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4, transaction5]
        let viewModel = HistoryViewModel(transactions: transactionArray, model: History())
        
        HistoryView(viewModel: viewModel)
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("No content") {
    VStack {
        let viewModel = HistoryViewModel(transactions: [], model: History())
        HistoryView(viewModel: viewModel)
            .environment(\.locale, .init(identifier: "es"))
    }
}
