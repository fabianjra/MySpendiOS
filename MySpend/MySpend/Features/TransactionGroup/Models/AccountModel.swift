//
//  AccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/2/25.
//

import Foundation
import SwiftData

@Model
class AccountModel: Identifiable {
    @Attribute(.unique) var id = UUID()
    
    var user: UserModel
    
    // If an account is deleted, avery transaction related to it also will be deleted.
    @Relationship(deleteRule: .cascade, inverse: \TransactionModel.account)
    var transactions: [TransactionModel]
    
    init(user: UserModel, transactions: [TransactionModel] = []) {
        self.user = user
        self.transactions = transactions
    }
}
