//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @ObservedObject var viewModel: TransactionHistoryViewModel
    
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
                    Picker("Transaction type", selection: $viewModel.historyFormat) {
                        ForEach(DateTimeInterval.allCases) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    //.colorMultiply(.primaryLeading)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.transactions) { item in
                            HStack {
                                TextPlain(message: item.category.description,
                                          lineLimit: ConstantViews.singleTextMaxLines)
                                
                                Spacer()
                                
                                TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol(),
                                          lineLimit: ConstantViews.singleTextMaxLines)
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

#Preview("With Content ES") {
    VStack {
        let array = [TransactionModel(amount: 56000,
                                      date: "25/05/1990",
                                      category: "Diario",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 3000.9,
                                      date: "25/05/2024",
                                      category: "Gastos mensuales del mes abc abc abcdefthijklmnbrto adfsafsdf a saf",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 100,
                                      date: "01/12/2003",
                                      category: "No category",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 301928564721.328,
                                      date: "01/05/2023",
                                      category: "Gastos mensuales del mes abc abc abcdefthijklmnbrto adfsafsdf a saf",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 3000.1,
                                      date: "25/05/2024",
                                      category: "Gastos mensuales",
                                      notes: "Nota",
                                      transactionType: .expense)]
        
        TransactionHistoryView(viewModel: TransactionHistoryViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("No content EN") {
    VStack {
        TransactionHistoryView(viewModel: TransactionHistoryViewModel())
            .environment(\.locale, .init(identifier: "en"))
    }
}
