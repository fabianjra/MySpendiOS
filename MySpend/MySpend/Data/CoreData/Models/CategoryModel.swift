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
    var type: CategoryType
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
    init(icon: String, name: String, type: CategoryType, userId: String = "") {
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
        type = CategoryModel.getCategoryType(from: category.type)
        usageCount = Int(category.usageCount)
    }
    
    static private func getCategoryType(from rawType: String?) -> CategoryType {
        return CategoryType(rawValue: rawType ?? CategoryType.expense.rawValue) ?? .expense
    }
}
