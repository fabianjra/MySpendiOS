//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

//TODO: Remover esta para utilizar el modelo de NewTransaction
struct TransactionModel: Identifiable, Codable, Equatable {
    public var id = UUID().uuidString
    let amount: Double
    let date: String
    let category: String
    let detail: String?
    let type: TransactionTypeEnum
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case date
        case category
        case detail
        case type
    }
}

enum TransactionTypeEnum: String, CaseIterable, Identifiable, Codable {
    public var id: Self { self }
    case expense = "expense"
    case income = "income"
}
