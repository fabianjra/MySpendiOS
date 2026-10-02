//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

struct CategoryModel: Identifiable, Equatable, Hashable {
    
    // Shared attributes (Abstract class):
    let dateCreated: Date
    let dateModified: Date
    var id = UUID()
    let isActive: Bool
    
    // Entity-specific Attributes
    let dateLastUsed: Date
    var icon: String // Emoji
    var name: String
    var type: CategoryType
    let usageCount: Int
    
    init(icon: String = "", name: String = "", type: CategoryType = .expense) {
        self.dateCreated = .init()
        self.dateModified = .init()
        self.isActive = true
        
        self.dateLastUsed = .init()
        self.icon = icon
        self.name = name
        self.type = type
        self.usageCount = .zero
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
        usageCount = entity.usageCount.toInt
    }
    
    static private func getCategoryType(from rawType: String?) -> CategoryType {
        return CategoryType(rawValue: rawType ?? CategoryType.expense.rawValue) ?? .expense
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
}
