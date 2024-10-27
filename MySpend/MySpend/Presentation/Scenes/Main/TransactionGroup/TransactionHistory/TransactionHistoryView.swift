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
                    Picker("Time interval", selection: $viewModel.dateTimeInvertal) {
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
                                TextPlain(message: item.category.name,
                                          lineLimit: ConstantViews.singleTextMaxLines)
                                
                                Spacer()
                                
                                TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol(),
                                          lineLimit: ConstantViews.singleTextMaxLines)
                            }
                            .padding(.vertical, ConstantViews.transactionsListVerticalSpacing)
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
        let array = [TransactionModel(id:"01",
                                      amount: 56000,
                                      date: "25/05/1990",
                                      category: CategoryModel(id: "01", name: "Gasolina"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id:"02",
                                      amount: 3000.9,
                                      date: "25/05/2024",
                                      category: CategoryModel(id: "02", name: "Comida"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id:"03",
                                      amount: 100,
                                      date: "01/12/2003",
                                      category: CategoryModel(id: "02", name: "Comida"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id:"04",
                                      amount: 301928564721.328,
                                      date: "01/05/2023",
                                      category: CategoryModel(id: "01", name: "Gasolina"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id:"05",
                                      amount: 3000.1,
                                      date: "25/05/2024",
                                      category: CategoryModel(id:"03", name: "Snacks"),
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
