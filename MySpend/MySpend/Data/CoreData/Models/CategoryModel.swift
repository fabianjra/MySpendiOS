//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

struct CategoryModel: Identifiable {
    
    
    // Shared attributes (Abstract class):
    let dateCreated: Date
    let dateModified: Date
    let id: UUID
    let isActive: Bool
    
    // Entity-specific Attributes
    let dateLastUsed: Date
    var icon: String // Emoji
    var name: String
    var type: TransactionType
    let usageCount: Int
    
    init() {
        dateCreated = .init()
        dateModified = .init()
        id = UUID()
        isActive = true
        
        dateLastUsed = .init()
        icon = ""
        name = ""
        type = .expense
        usageCount = .zero
    }
    
    // When a new category is created
    init(icon: String, name: String, type: TransactionType, userId: String = "") {
        self.init()
        self.icon = icon
        self.name = name
        self.type = type
    }
    
    // When a category is going to load from Core Data and need to map to Category Model
    init(_ category: Category) {
        dateCreated = category.dateCreated ?? .init()
        dateModified = category.dateModified ?? .init()
        id = category.id ?? UUID()
        isActive = category.isActive
        
        dateLastUsed = category.dateLastUsed ?? .init()
        icon = category.icon ?? ""
        name = category.name ?? ""
        type = CategoryModel.getTransactionType(from: category.type)
        usageCount = Int(category.usageCount)
    }
    
    static private func getTransactionType(from rawType: String?) -> TransactionType {
        return TransactionType(rawValue: rawType ?? TransactionType.expense.rawValue) ?? .expense
    }
}
