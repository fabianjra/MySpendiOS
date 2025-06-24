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
    let icon: String // Emoji
    let isActive: Bool
    let name: String
    let type: TransactionType
    let usageCount: Int
    let userId: String
    
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
        userId = ""
    }
    
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
        userId = category.userId ?? ""
    }
}
