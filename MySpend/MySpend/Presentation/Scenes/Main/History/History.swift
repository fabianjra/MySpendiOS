//
//  History.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

struct History {
    var transactions: [TransactionModel] = []
    var historyFormat: HistoryFormatEnum = .month
}

enum HistoryFormatEnum: String, CaseIterable {
    case day = "Daily"
    case week = "Weekly"
    case month = "Monthly"
    case year = "Yearly"
}
