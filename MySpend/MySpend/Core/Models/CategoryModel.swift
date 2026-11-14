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
    
    // Entity-specific Attributes
    let dateLastUsed: Date?
    var icon: String // Emoji
    var name: String
    var usageCount: Int
    var type: CategoryType
    
    init(icon: String = "", name: String = "", type: CategoryType = .expense) {
        self.dateCreated = .init()
        self.dateModified = .init()
        
        self.dateLastUsed = nil
        self.icon = icon
        self.name = name
        self.usageCount = .zero
        self.type = type
    }
    
    // When a category is going to load from Core Data and need to map to Category Model
    init(_ entity: Category) {
        dateCreated = entity.dateCreated ?? .init()
        dateModified = entity.dateModified ?? .init()
        id = entity.id ?? UUID()
        
        dateLastUsed = entity.dateLastUsed
        icon = entity.icon ?? ""
        name = entity.name ?? ""
        usageCount = Int(entity.usageCount)
        type = CategoryModel.getCategoryType(from: entity.type)
    }
    
    static private func getCategoryType(from rawType: String?) -> CategoryType {
        return CategoryType(rawValue: rawType ?? CategoryType.expense.rawValue) ?? .expense
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
}
