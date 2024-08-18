//
//  HistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if viewModel.model.transactions.isEmpty {
                Spacer()
                TextPlain(message: "No transactions added",
                          family: .semibold,
                          size: .bigXL)
                Spacer()
            } else {
                VStack {
                    

                    Picker("Transaction type", selection: $viewModel.model.historyFormat) {
                        ForEach(HistoryFormatEnum.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    //.colorMultiply(.primaryLeading)
                    .padding(.bottom)
                    
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.model.transactions) { item in
                            HStack {
                                TextPlain(message: item.categoryId.description,
                                          lineLimit: 1)
                                .truncationMode(.middle)
                                
                                Spacer()
                                
                                TextPlain(message: "$ \(item.amount.roundedToTwoDecimalsString())")
                            }
                            .padding(.vertical, ConstantViews.textResumeSpacing)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            
            
            TextError(message: viewModel.errorMessage)
        }
        .onAppear {
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
        let transaction2 = TransactionModel(amount: 3000,
                                            date: "25/05/2024",
                                            categoryId: "Gastos mensuales del mes abc abc abcdefthijklmnbrto adfsafsdf a saf",
                                            detail: "Nota",
                                            type: .expense)
        let transaction3 = TransactionModel(amount: 100,
                                            date: "01/12/2003",
                                            categoryId: "No category",
                                            detail: "Nota",
                                            type: .expense)
        let transaction4 = TransactionModel(amount: 270000,
                                            date: "01/05/2023",
                                            categoryId: "04",
                                            detail: "Nota",
                                            type: .expense)
        
        let transactionArray = [transaction1, transaction2, transaction3, transaction4]
        
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
