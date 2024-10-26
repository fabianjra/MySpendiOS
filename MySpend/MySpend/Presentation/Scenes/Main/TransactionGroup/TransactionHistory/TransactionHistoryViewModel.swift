//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Combine

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var transactions: [TransactionModel]
    @Published var model: TransactionHistory
    
    init(transactions: [TransactionModel], model: TransactionHistory = TransactionHistory()) {
        self.transactions = transactions
        self.model = model
    }
    
}
