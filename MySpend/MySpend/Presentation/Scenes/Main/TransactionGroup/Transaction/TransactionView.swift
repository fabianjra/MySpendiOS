//
//  TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TransactionView: View {
    
    @StateObject var viewModel = TransactionViewModel()
    
    var body: some View {
        ContentContainer {
            
            // MARK: HEADER
            HStack {
                VStack(alignment: .leading) {
                    TextPlain("Hello \(viewModel.userName) \(Emojis.greeting.rawValue)",
                              family: .semibold,
                              size: .big,
                              lineLimit: ConstantViews.singleTextMaxLines,
                              truncateMode: .tail)
                    
                    TextPlain("Welcome back",
                              family: .light,
                              size: .small,
                              lineLimit: ConstantViews.singleTextMaxLines)
                }
                Spacer()
            }
            
            
            // MARK: HISTORY BUTTON
            VStack {
                NavigationLink {
                    TransactionHistoryView(transactionsLoaded: $viewModel.transactions,
                                           dateTimeInterval: $viewModel.dateTimeInterval,
                                           selectedDate: $viewModel.selectedDate)
                    .toolbar(.hidden, for: .navigationBar)
                } label: {
                    TextButtonHorizontalStyled("History",
                                               subTitle: "Go to history",
                                               iconLeading: Image.stackFill,
                                               iconTrailing: Image.arrowRight)
                }
            }
            
            
            // MARK: TRANSACTIONS
            if viewModel.isLoading {
                LoaderView()
            } else {
                if viewModel.transactions.isEmpty {
                    NoContentView(title: "No transactions")
                    Spacer()
                } else {
                    VStack {
                        DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval, selectedDate: $viewModel.selectedDate)
                        
                        let transactionsFiltered = UtilsTransactions.filteredTransactions(viewModel.selectedDate,
                                                                                          transactions: viewModel.transactions,
                                                                                          for: viewModel.dateTimeInterval)
                        
                        let groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered)
                            .sorted(by: { $0.totalAmount > $1.totalAmount })
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(groupedTransactions, id:\.category.id) { item in
                                HStack {
                                    TextPlain(item.category.name)
                                    
                                    Spacer()
                                    
                                    TextPlain(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                }
                                .padding(.vertical, ConstantViews.minimumSpacing)
                            }
                        }
                        .animation(.default, value: transactionsFiltered.count)
                        
                        TextError(viewModel.errorMessage)
                        
                        TotalBalanceView(transactions: .constant(transactionsFiltered)) //TODO: Cambiar por variable en viewModel para que sea Binding.
                    }
                    
                    //Tiene un efecto no deseado al transicionar entre tab y tab.
                    //TODO: Revisar si con listener se comporta diferente.
                    //.redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
            }
        }
        .onAppear {
            print("Router count RESUME: \(Router.shared.path.count)")
            viewModel.fetchUserName()
        }
        .onFirstAppear {
            viewModel.fetchData()
        }
    }
}

#Preview("es_CR") {
    VStack {
        TransactionView(viewModel: TransactionViewModel(transactions: MockTransactions.normal))
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}

#Preview("Saturated en_US") {
    VStack {
        TransactionView(viewModel: TransactionViewModel(transactions: MockTransactions.saturated))
            .environment(\.locale, .init(identifier: "en_US"))
    }
}

#Preview("No content es_ES") {
    TransactionView(viewModel: TransactionViewModel())
        .environment(\.locale, .init(identifier: "es_ES"))
}
