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
            
            // MARK: RESUME
            if viewModel.isLoading {
                LoaderView()
            } else {
                if viewModel.transactions.isEmpty {
                    Spacer()
                    TextPlain(message: "No transactions",
                              family: .semibold,
                              size: .bigXL,
                              aligment: .center)
                    .padding(.vertical)
                    
                    TextPlain(message: "Try adding a new one in the + button",
                              size: .big,
                              aligment: .center)
                    Spacer()
                } else {
                    VStack {
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
        let array = [TransactionModel(amount: 56000,
                                      date: "25/05/1990",
                                      category: "01",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 3000.00,
                                      date: "25/05/2024",
                                      category: "02",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 100.12,
                                      date: "01/12/2003",
                                      category: "03",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 270046.7802,
                                      date: "01/05/2023",
                                      category: "05",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 270000,
                                      date: "01/05/2023",
                                      category: "04",
                                      notes: "Nota",
                                      transactionType: .expense)]

        TransactionView(viewModel: TransactionViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("Saturated content EN") {
    VStack {
        let array = [TransactionModel(amount: 56000234234.23434,
                                      date: "25/05/1990",
                                      category: "alsjdfasjflkasj dflkasjdlkfjaslkfjalsk asd f",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 3002342340.00,
                                      date: "25/05/2024",
                                      category: "02",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 100.12,
                                      date: "01/12/2003",
                                      category: "asdfasdfasdfasdfk jkfj askjf aksjf ksjf kasjf kasf jk",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 27677776763244437674.23423434,
                                      date: "01/05/2023",
                                      category: "asdf asfa",
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(amount: 270046.7802,
                                      date: "01/05/2023",
                                      category: "05",
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
