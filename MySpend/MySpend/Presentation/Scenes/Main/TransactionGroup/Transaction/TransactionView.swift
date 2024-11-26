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
                        
                        let viewModelFiltered = UtilsTransactions.filteredTransactions(viewModel.selectedDate,
                                                                                       transactions: viewModel.transactions,
                                                                                       for: viewModel.dateTimeInterval)
                        
                        let groupedTransactions = UtilsCurrency.calculateGroupedTransactions(viewModelFiltered)
                            .sorted(by: { $0.totalAmount > $1.totalAmount })
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(groupedTransactions, id:\.category.id) { item in
                                HStack {
                                    TextPlain(item.category.name)
                                    
                                    Spacer()
                                    
                                    TextPlain(item.totalAmount.convertAmountDecimalToString().addCurrencySymbol())
                                }
                                .padding(.vertical, ConstantViews.minimumSpacing)
                            }
                        }
                        
                        TextError(viewModel.errorMessage)
                        
                        TotalBalanceView(transactions: .constant(viewModelFiltered)) //TODO: Cambiar por variable en viewModel para que sea Binding.
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

#Preview("Content ES") {
    VStack {
        let array = [TransactionModel(id: "01",
                                      amount: 100,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "01",
                                                              name: "Gasolina",
                                                              categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "02",
                                      amount: 200,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "02",
                                                              name: "Comida",
                                                              categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "03",
                                      amount: 50,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "02",
                                                              name: "Comida",
                                                              categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "04",
                                      amount: 50,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "01",
                                                              name: "Gasolina",
                                                              categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "05",
                                      amount: 5000,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "03",
                                                              name: "Recarga saldo",
                                                              categoryType: .income),
                                      notes: "Nota",
                                      transactionType: .income)]
        
        TransactionView(viewModel: TransactionViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("Saturated content EN") {
    VStack {
        let array = [TransactionModel(id: "01",
                                      amount: 142342342354234,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "01", name: "Gasolina asdfsaf asdfasd fsadf as fas", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "02",
                                      amount: 52354234532523,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "02",name: "Comidaasf safasdf saf sa asdffasdfasryewrrts fsadf s", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "03",
                                      amount: 34523452345324,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "02",name: "Comida", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "04",
                                      amount: 50,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "01",name: "Gasolina", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "05",
                                      amount: 500523532535325320,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "03",name: "Recarga saldo", categoryType: .income),
                                      notes: "Nota",
                                      transactionType: .income)]
        
        TransactionView(viewModel: TransactionViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "en"))
    }
}

#Preview("No content ES") {
    TransactionView(viewModel: TransactionViewModel())
        .environment(\.locale, .init(identifier: "es"))
}
