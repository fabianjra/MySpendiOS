//
//  AccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

// Se agrega el sufijo "Model" para diferenciarlo de la entidad de CoreDate (sin el sufijo model).
struct AccountModel: Identifiable {
    
    // Shared attributes (Abstract class):
    let dateCreated: Date
    let dateModified: Date
    let id: UUID
    let isActive: Bool
    
    // Entity-specific Attributes
    let icon: String // Emoji
    let name: String
    let notes: String
    let type: String // Maybe to be used only for expenses or incomes. Use ENUM.
    let userId: String // For Firebase
    
    // Relationships
    let transactions: [TransactionModel]
    
    init() {
        dateCreated = .init()
        dateModified = .init()
        id = UUID()
        isActive = false
        
        icon = ""
        name = ""
        notes = ""
        type = ""
        userId = ""
        transactions = []
    }
    
    init(account: Account) {
        dateCreated = account.dateCreated ?? .init()
        dateModified = account.dateModified ?? .init()
        id = account.id ?? UUID()
        isActive = account.isActive
        
        icon = account.icon ?? ""
        name = account.name ?? ""
        notes = account.notes ?? ""
        type = account.type ?? ""
        userId = account.userId ?? ""
        transactions = AccountModel.convertTransactions(accountCoreData: account)
    }
    
    private static func convertTransactions(accountCoreData: Account) -> [TransactionModel] {
        (accountCoreData.transaction as? Set<Transaction>)?.map { TransactionModel($0) } ?? []
    }
}
