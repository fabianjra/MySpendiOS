//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation
import SwiftData

@Model
class CategoryModel: Identifiable, Equatable, Hashable  {
    @Attribute(.unique) var id = UUID()
    
    // Visual:
    var icon: String
    var name: String
    var categoryType: CategoryType
    
    // Management:
    var dateCreated: Date
    var datemodified: Date
    var usedCounter: Int
    
    
    // If a category is deleted, avery transaction related to it also will be deleted.
    @Relationship(deleteRule: .cascade, inverse: \TransactionModel.category)
    var transaction: TransactionModel
    
    init(icon: String,
         name: String,
         categoryType: CategoryType,
         datemodified: Date,
         transaction: TransactionModel) {
        
        self.icon = icon
        self.name = name
        self.categoryType = categoryType
        self.datemodified = datemodified
        self.transaction = transaction
        
        // Default values
        self.dateCreated = .now
        self.usedCounter = 0
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
    
    func incrementUsedCounter() {
        self.usedCounter += 1
    }
}
