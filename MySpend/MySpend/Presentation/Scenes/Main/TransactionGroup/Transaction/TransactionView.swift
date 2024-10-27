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
                    let historyViewModel = TransactionHistoryViewModel(transactions: viewModel.transactions)
                    
                    TransactionHistoryView(viewModel: historyViewModel)
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
                            ForEach(viewModel.groupedTransactions, id:\.category.id) { item in
                                HStack {
                                    TextPlain(message: item.category.name)
                                    
                                    Spacer()
                                    
                                    TextPlain(message: item.totalAmount.convertAmountDecimalToString().addCurrencySymbol())
                                }
                                .padding(.vertical, ConstantViews.transactionsListVerticalSpacing)
                                .padding(.horizontal)
                            }
                        }
                        
                        DividerView()
                            .background(.blue)
                        
                        // MARK: TOTAL BALANCE
                        HStack {
                            TextPlain(message: "Balance",
                                      size: .big)
                            Spacer()
                            
                            TextPlain(message: viewModel.totalBalanceFormatted,
                                      size: .big)
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
        
        TransactionView(viewModel: TransactionViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("Saturated content EN") {
    VStack {
        let array = [TransactionModel(id: "01",
                                      amount: 56000234234.23434,
                                      date: "25/05/1990",
                                      category: CategoryModel(id: "01",name: "01a sdfas dfas fsaf sa f"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "02",
                                      amount: 3002342340.00,
                                      date: "25/05/2024",
                                      category: CategoryModel(id: "02",name: "02a dfas fas fsaf asf saf "),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "03",
                                      amount: 100.12,
                                      date: "01/12/2003",
                                      category: CategoryModel(id: "03",name: "03a sfsa fdasdfasdfasfsaf"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "04",
                                      amount: 27677776763244437674.23423434,
                                      date: "01/05/2023",
                                      category: CategoryModel(id: "04",name: "0435345345325235325"),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "05",
                                      amount: 270046.7802,
                                      date: "01/05/2023",
                                      category: CategoryModel(id: "05",name: "05 fsa fsaf asd fsaf sa fas fsa "),
                                      notes: "Nota",
                                      transactionType: .expense)]
        
        TransactionView(viewModel: TransactionViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "en"))
    }
}

#Preview("No content ES") {
    TransactionView(viewModel: TransactionViewModel())
        .environment(\.locale, .init(identifier: "es"))
}
