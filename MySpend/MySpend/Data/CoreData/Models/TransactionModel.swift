//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct TransactionModel: Identifiable, Codable, Equatable, Hashable {
    var id = ""
    var amount: Decimal = .zero
    var dateTransaction: Date = .init()
    var category: CategoryModel = CategoryModel()
    var notes: String = ""
    var transactionType: TransactionType = .expense
    var dateCreated: Date = .init()
    var datemodified: Date = .init()
    var userId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case dateTransaction
        case category
        case notes
        case transactionType
        case dateCreated
        case datemodified
        case userId
    }
    
    enum Field: Hashable, CaseIterable {
        case amount
        case notes
    }
}
