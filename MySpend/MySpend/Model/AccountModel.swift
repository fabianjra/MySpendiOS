//
//  AccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/2/25.
//

struct AccountModel: Identifiable, Codable {
    let id: String
    let transactions: [TransactionModel]
}
