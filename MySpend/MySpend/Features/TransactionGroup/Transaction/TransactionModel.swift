//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation
import SwiftData

@Model
class TransactionModel: Identifiable, Equatable, Hashable {
    @Attribute(.unique) var id = UUID()
    
    // Visual:
    var dateTransaction: Date
    var amount: Decimal
    var category: CategoryModel
    var account: AccountModel
    var notes: String
    var repeating: Bool
    
    // Management:
    var dateCreated: Date
    var datemodified: Date
    
    init(dateTransaction: Date,
         amount: Decimal,
         category: CategoryModel,
         account: AccountModel,
         notes: String,
         repeating: Bool) {
        
        self.dateTransaction = dateTransaction
        self.amount = amount
        self.category = category
        self.account = account
        self.notes = notes
        self.repeating = repeating
        
        // Default values:
        self.dateCreated = .now
        self.datemodified = .now
    }
    
    enum Field: Hashable, CaseIterable {
        case amount
        case notes
    }
}
