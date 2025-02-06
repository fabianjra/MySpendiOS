//
//  SortTransactions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/12/24.
//

import SwiftUI

enum SortTransactions: String, Codable {
    case byDateNewest = "Date newest"
    case byDateOldest = "Date oldest"
    
    case byAmountHigher = "Amount higher"
    case byAmountLower = "Amount lower"
    
    case byCategoryNameAz = "Name Az"
    case byCategoryNameZa = "Name Za"
    
    var toggle: SortTransactions {
        switch self {
        case .byDateNewest: return .byDateOldest
        case .byDateOldest: return .byDateNewest
            
        case .byAmountHigher: return .byAmountLower
        case .byAmountLower: return .byAmountHigher
            
        case .byCategoryNameAz: return .byCategoryNameZa
        case .byCategoryNameZa: return .byCategoryNameAz
        }
    }
    
    func label(inverted: Bool = true) -> some View {
        switch self {
        case .byDateNewest: return inverted ? Label.dateOldestFirst : Label.dateNewestFirst
        case .byDateOldest: return inverted ? Label.dateNewestFirst : Label.dateOldestFirst
            
        case .byAmountHigher: return inverted ? Label.amountLowestFirst : Label.amountHighesttFirst
        case .byAmountLower: return inverted ? Label.amountHighesttFirst : Label.amountLowestFirst
            
        case .byCategoryNameAz: return inverted ? Label.categoryNameZa : Label.categoryNameAz
        case .byCategoryNameZa: return inverted ? Label.categoryNameAz : Label.categoryNameZa
        }
    }
}
