//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct CategoryModel: Identifiable, Codable, Equatable  {
    public var id = UUID().uuidString
    let icon: String?   
    let description: String
    let categoryType: TransactionTypeEnum
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case description
        case categoryType
    }
}
