//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct TransactionModelFB: Identifiable, Codable, Equatable, Hashable {
    var id = ""
    var amount: Decimal = .zero
    var dateTransaction: Date = .init()
    var category: CategoryModelFB = CategoryModelFB()
    var notes: String = ""
    var categoryType: CategoryType = .expense
    var dateCreated: Date = .init()
    var datemodified: Date = .init()
    var userId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case dateTransaction
        case category
        case notes
        case categoryType
        case dateCreated
        case datemodified
        case userId
    }
    
    enum Field: Hashable, CaseIterable {
        case amount
        case notes
    }
}
