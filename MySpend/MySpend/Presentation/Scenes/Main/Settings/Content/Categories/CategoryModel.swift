//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct CategoryModel: Identifiable, Codable, Equatable  {
    public var id = UUID().uuidString
    var icon: String = ""
    var name: String = ""
    var categoryType: TransactionTypeEnum = .expense
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case name
        case categoryType
    }
}
