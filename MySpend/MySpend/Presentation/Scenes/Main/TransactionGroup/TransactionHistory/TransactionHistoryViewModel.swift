//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var transactions: [TransactionModel]
    @Published var transactionToModify = TransactionModel()
    
    @Published var dateTimeInvertal: DateTimeInterval = .month
    @Published var selectedMonth: Int = .zero // Indice de 0 a 11, siendo enero = 0

    let dateFormatter = DateFormatter()
    var monthSymbols: [String] = []
    
    
    @Published var showModifyTransactionModal = false

    init(transactions: [TransactionModel] = []) {
        self.transactions = transactions
        
        monthSymbols = dateFormatter.monthSymbols // ["January", "February", ..., "December"]
        selectedMonth = Calendar.current.component(.month, from: Date()) - 1
    }
}
