//
//  HistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Combine

class HistoryViewModel: BaseViewModel {
    
    @Published var transactions: [TransactionModel]
    @Published var model: History
    
    init(transactions: [TransactionModel], model: History = History()) {
        self.transactions = transactions
        self.model = model
    }
    
}
