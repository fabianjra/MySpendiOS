//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct CategoryModel: Identifiable, Codable, Equatable  {
    public var id = UUID().uuidString
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
    }
}
