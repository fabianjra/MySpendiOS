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
    init(icon: String, name: String, type: CategoryType) {
        self.init()
        self.icon = icon
        self.name = name
        self.type = type
    }
    
    // When a category is going to load from Core Data and need to map to Category Model
    init(_ entity: Category) {
        dateCreated = entity.dateCreated ?? .init()
        dateModified = entity.dateModified ?? .init()
        id = entity.id ?? UUID()
        isActive = entity.isActive
        
        dateLastUsed = entity.dateLastUsed ?? .init()
        icon = entity.icon ?? ""
        name = entity.name ?? ""
        type = CategoryModel.getCategoryType(from: entity.type)
        usageCount = Int(entity.usageCount)
    }
    
    static private func getCategoryType(from rawType: String?) -> CategoryType {
        return CategoryType(rawValue: rawType ?? CategoryType.expense.rawValue) ?? .expense
    }
}
