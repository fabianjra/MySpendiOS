//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

struct TransactionModel {
    
    // Shared attributes (Abstract class):
    let dateCreated: Date
    let dateModified: Date
    let id: UUID
    let isActive: Bool
    
    // Entity-specific Attributes
    let amount: Decimal
    let dateTransaction: Date
    let notes: String
    
    // Relationships
    let category: CategoryModel
    
    init() {
        dateCreated = .init()
        dateModified = .init()
        id = UUID()
        isActive = false
        
        amount = .zero
        dateTransaction = .init()
        notes = ""
        category = CategoryModel()
    }
    
    init(_ transaction: Transaction) {
        dateCreated = transaction.dateCreated ?? .init()
        dateModified = transaction.dateModified ?? .init()
        id = transaction.id ?? UUID()
        isActive = transaction.isActive
        
        amount = transaction.amount?.decimalValue ?? .zero
        dateTransaction = transaction.dateTransaction ?? .init()
        notes = transaction.notes ?? ""
        category = TransactionModel.convertToCategoryModel(transaction.category)
    }
    
    private static func convertToCategoryModel(_ categoryCoreData: Category?) -> CategoryModel {
        if let category = categoryCoreData {
            return CategoryModel(category)
        } else {
            return CategoryModel()
        }
    }
}
