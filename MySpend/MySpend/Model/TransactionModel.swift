//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct TransactionModel: Identifiable, Codable {
    var id: String?
    let amount: Double?
    let date: Date?
    let category: CategoryModel?
    let detail: String?
    let type: TransactionTypeEnum?
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case date
        case category
        case detail
        case type
    }
}

enum TransactionTypeEnum: String, Codable {
    case Expense
    case Income
}
