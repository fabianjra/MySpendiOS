//
//  UtilsCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/12/24.
//

import Foundation

extension Array where Element == CategoryModel {
    
    func sortedCategories(by sort: CategorySortConfiguration) -> [CategoryModel] {
        switch sort.sortBy {
            
        case .title:
            return sorted {
                sort.order == .ascending
                ? $0.name.localizedStandardCompare($1.name) == .orderedAscending
                : $0.name.localizedStandardCompare($1.name) == .orderedDescending
            }
            
        case .dateCreated:
            return sorted {
                sort.order == .ascending
                ? $0.dateCreated < $1.dateCreated
                : $0.dateCreated > $1.dateCreated
            }
            
        case .usage:
            return sorted {
                sort.order == .ascending
                ? $0.dateLastUsed > $1.dateLastUsed
                : $0.dateLastUsed < $1.dateLastUsed
            }
        }
    }
}
