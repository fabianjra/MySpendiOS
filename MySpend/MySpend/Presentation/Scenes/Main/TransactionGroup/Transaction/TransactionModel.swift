//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct TransactionModel: Identifiable, Codable {
    var id = ""
    var amount: Decimal = .zero
    var date: String = ""
    var category: String = ""
    var notes: String = ""
    var transactionType: TransactionType = .expense
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case date
        case category
        case notes
        case transactionType
    }
    
    enum Field: Hashable, CaseIterable {
        case amount
        case notes
    }
}
