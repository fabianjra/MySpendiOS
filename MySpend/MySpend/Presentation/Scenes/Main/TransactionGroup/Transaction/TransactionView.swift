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
                    
                    TextPlain(message: "Hello \(viewModel.userName) \(Emojis.greeting.rawValue)",
                              family: .semibold,
                              size: .big,
                              lineLimit: ConstantViews.singleTextMaxLines,
                              truncateMode: .tail)
                    
                    TextPlain(message: "Welcome back",
                              family: .light,
                              size: .small,
                              lineLimit: ConstantViews.singleTextMaxLines)
                }
                .foregroundColor(Color.textPrimaryForeground)
                Spacer()
            }
            .padding(.bottom)
            
            
            // MARK: HISTORY BUTTON
            VStack {
                NavigationLink {
                    TransactionHistoryView(transactionsLoaded: $viewModel.transactions)
                        .toolbar(.hidden, for: .navigationBar)
                } label: {
                    TextButtonHorizontalStyled(text: "History",
                                               subTitle: "Go to history",
                                               iconLeading: Image.stackFill,
                                               iconTrailing: Image.arrowRight)
                }
            }
            
            
            TextError(message: viewModel.errorMessage)
            
            // MARK: TRANSACTIONs
            if viewModel.isLoading {
                LoaderView()
            } else {
                if viewModel.transactions.isEmpty {
                    NoContentView(title: "No transactions")
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
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.groupedTransactions.sorted(by: { $0.totalAmount > $1.totalAmount }), id:\.category.id) { item in
                                HStack {
                                    TextPlain(message: item.category.name)
                                    
                                    Spacer()
                                    
                                    TextPlain(message: item.totalAmount.convertAmountDecimalToString().addCurrencySymbol())
                                }
                                .padding(.vertical, ConstantViews.minimumSpacing)
                                .padding(.horizontal)
                            }
                        }
                        
                        DividerView()
                            .background(.blue)
                        
                        // MARK: BALANCES
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
                        
                        
                        HStack {
                            TextPlain(message: "Total balance", size: .big)
                            Spacer()
                            TextPlain(message: viewModel.totalBalanceFormatted, size: .big)
                        }
                    }
                    .padding(.bottom, ConstantViews.paddingBottomResumeview)
                    
                    //Tiene un efecto no deseado al transicionar entre tab y tab.
                    //TODO: Revisar si con listener se comporta diferente.
                    //.redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
            }
        }
        .onAppear {
            print("Router count RESUME: \(Router.shared.path.count)")
            viewModel.onAppear()
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
