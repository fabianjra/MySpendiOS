//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

struct TransactionModel {
    let id: UUID
    
    // MARK: Attributes
    let amount: Decimal
    let dateCreated: Date
    let dateModified: Date
    let dateTransaction: Date
    let isActive: Bool
    let notes: String
    
    // MARK: Relationships
    let category: CategoryModel
    
    init() {
        id = UUID()
        amount = .zero
        dateCreated = .init()
        dateModified = .init()
        dateTransaction = .init()
        isActive = false
        notes = ""
        category = CategoryModel()
    }
    
    init(transaction: Transaction) {
        id = transaction.id ?? UUID()
        amount = transaction.amount?.decimalValue ?? .zero
        dateCreated = transaction.dateCreated ?? .init()
        dateModified = transaction.dateModified ?? .init()
        dateTransaction = transaction.dateTransaction ?? .init()
        isActive = transaction.isActive
        notes = transaction.notes ?? ""
        category = TransactionModel.convertCategoryToCategoryModel(categoryCoreData: transaction.category)
    }
    
    private static func convertCategoryToCategoryModel(categoryCoreData: Category?) -> CategoryModel {
        if let categoryCoreData = categoryCoreData {
            return CategoryModel(categoryCoreData)
        } else {
            return CategoryModel()
        }
    }
}
