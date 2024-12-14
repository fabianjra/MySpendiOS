//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct CategoryModel: Identifiable, Codable, Equatable, Hashable  {
    var id: String = ""
    var icon: String = CategoryIcons.household.list.first ?? "tag.fill"
    var name: String = ""
    var categoryType: TransactionType = .expense
    var dateCreated: Date = .init()
    var datemodified: Date = .init()
    var userId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case name
        case categoryType
        case dateCreated
        case datemodified
        case userId
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
}
