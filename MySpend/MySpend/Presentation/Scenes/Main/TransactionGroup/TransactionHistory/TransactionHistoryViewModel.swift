//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var transactions: [TransactionModel]
    @Published var dateTimeInvertal: DateTimeInterval = .month

    init(transactions: [TransactionModel] = []) {
        self.transactions = transactions
    }
}
