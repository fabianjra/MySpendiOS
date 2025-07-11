//
//  TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI
import CoreData

struct TransactionView: View {
    
    @StateObject var viewModel = TransactionViewModel()
    @Binding var selectedDate: Date
    
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
                                           selectedDate: $selectedDate)
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
                    NoContentToAddView(title: "No transactions")
                    Spacer()
                } else {
                    VStack {
                        DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                                  selectedDate: $selectedDate,
                                                  isEditing: .constant(false)){}
                        
                        let transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
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
                        
                        TotalBalanceView(transactions: transactionsFiltered)
                    }
                    
                    //Tiene un efecto no deseado al transicionar entre tab y tab.
                    //TODO: Revisar si con listener se comporta diferente.
                    //.redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
            }
        }
        .onAppear {
            print("Router count RESUME: \(Router.shared.path.count)")
            viewModel.activateObservers()
            viewModel.refreshUserName()
        }
        .onDisappear {
            viewModel.deactivateObservers()
        }
    }
}

#Preview("es_CR") {
    @Previewable @State var selectedDate = Date()
    VStack {
        TransactionView(selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}

#Preview("Saturated en_US") {
    @Previewable @State var selectedDate = Date()
    VStack {
        TransactionView(selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "en_US"))
    }
}

#Preview("No content es_ES") {
    @Previewable @State var selectedDate = Date()
    TransactionView(selectedDate: $selectedDate)
        .environment(\.locale, .init(identifier: "es_ES"))
}
