//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct Category: Identifiable, Codable, Equatable  {
    public var id = UUID().uuidString
    let icon: String?
    let description: String
    let type: TransactionTypeEnum
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case description
        case type
    }
}
