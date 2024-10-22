//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct CategoryModel: Identifiable, Codable, Equatable  {
    var id: String = ""
    var icon: String = ConstantIcons.defaultIcon
    var name: String = ""
    var categoryType: TransactionType = .expense
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case name
        case categoryType
    }
}
