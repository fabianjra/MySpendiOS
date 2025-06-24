//
//  AccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

// Se agrega el sufijo "Model" para diferenciarlo de la entidad de CoreDate (sin el sufijo model).
struct AccountModel: Identifiable {
    let id: UUID
    
    // MARK: Attributes
    let dateCreated: Date
    let dateModified: Date
    let icon: String // Emoji
    let isActive: Bool
    let name: String
    let notes: String
    let type: String // Maybe to be only expenses or incomes. Use ENUM.
    let userId: String
    
    // MARK: Relationships
    let transactions: [TransactionModel]
    
    init() {
        id = UUID()
        dateCreated = .init()
        dateModified = .init()
        icon = ""
        isActive = false
        name = ""
        notes = ""
        type = ""
        userId = ""
        transactions = []
    }
    
    init(account: Account) {
        id = account.id ?? UUID()
        dateCreated = account.dateCreated ?? .init()
        dateModified = account.dateModified ?? .init()
        icon = account.icon ?? ""
        isActive = account.isActive
        name = account.name ?? ""
        notes = account.notes ?? ""
        type = account.type ?? ""
        userId = account.userId ?? ""
        transactions = AccountModel.convertTransactions(accountCoreData: account)
    }
    
    private static func convertTransactions(accountCoreData: Account) -> [TransactionModel] {
        (accountCoreData.transaction as? Set<Transaction>)?.map { TransactionModel(transaction: $0) } ?? []
    }
}
