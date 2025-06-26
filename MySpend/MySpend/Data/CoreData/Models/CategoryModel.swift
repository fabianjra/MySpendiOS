//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

struct CategoryModel: Identifiable {
    let id: UUID
    
    // MARK: Attributes
    let dateCreated: Date
    let dateLastUsed: Date
    let dateModified: Date
    var icon: String // Emoji
    let isActive: Bool
    var name: String
    var type: TransactionType
    let usageCount: Int
    
    init() {
        id = UUID()
        dateCreated = .init()
        dateLastUsed = .init()
        dateModified = .init()
        icon = ""
        isActive = true
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
    init(category: Category) {
        id = category.id ?? UUID()
        dateCreated = category.dateCreated ?? .init()
        dateLastUsed = category.dateLastUsed ?? .init()
        dateModified = category.dateModified ?? .init()
        icon = category.icon ?? ""
        isActive = category.isActive
        name = category.name ?? ""
        type = TransactionType(rawValue: category.type ?? "expense") ?? .expense
        usageCount = Int(category.usageCount)
    }
}
