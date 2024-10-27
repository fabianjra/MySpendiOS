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
                                VStack(alignment: .leading) {
                                    TextPlain(message: item.category.name)
                                    TextPlain(message: item.date, size: .small)
                                }
                                
                                Spacer()
                                
                                TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol())
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
        let array = [TransactionModel(id: "01",
                                      amount: 100,
                                      date: "25/05/1990",
                                      category: CategoryModel(id: "01", name: "Gasolina", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "02",
                                      amount: 200,
                                      date: "25/05/2024",
                                      category: CategoryModel(id: "02",name: "Comida", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "03",
                                      amount: 50,
                                      date: "01/12/2003",
                                      category: CategoryModel(id: "02",name: "Comida", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "04",
                                      amount: 50,
                                      date: "01/05/2023",
                                      category: CategoryModel(id: "01",name: "Gasolina", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "05",
                                      amount: 5000,
                                      date: "01/05/2023",
                                      category: CategoryModel(id: "03",name: "Recarga saldo", categoryType: .income),
                                      notes: "Nota",
                                      transactionType: .income)]
        
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
