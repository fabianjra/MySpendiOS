//
//  HistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct HistoryView: View {
    //TODO: Pasar el viewModel por parametro.
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            
            if viewModel.isLoading {
                ZStack {
                    LinearGradient(colors: Color.primaryGradiant,
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .mask(Loader()
                        .frame(width: FrameSize.width.loaderFullScreen,
                               height: FrameSize.height.loaderFullScreen,
                               alignment: .center)
                    )
                }
            } else {
                if viewModel.model.transactions.isEmpty {
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
                        Picker("Transaction type", selection: $viewModel.model.historyFormat) {
                        ForEach(HistoryFormatEnum.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                        //.colorMultiply(.primaryLeading)
                    
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.model.transactions) { item in
                                HStack {
                                    TextPlain(message: item.categoryId.description,
                                              lineLimit: ConstantViews.transactionsMaxLines)
                                    
                                    Spacer()
                                    //TODO: Agregar symbol Currency
                                    TextPlain(message: item.amount.convertAmountDecimalToString(),
                                              lineLimit: ConstantViews.transactionsMaxLines)
                                }
                                .padding(.vertical, ConstantViews.textResumeSpacing)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            
            
            TextError(message: viewModel.errorMessage)
                .padding(.bottom)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
            Task {
                await viewModel.getTransactions()
            }
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
        let model = History(transactions: transactionArray)
        let viewModel = HistoryViewModel(model: model)
        
        HistoryView(viewModel: viewModel)
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("No content") {
    HistoryView()
        .environment(\.locale, .init(identifier: "es"))
}
