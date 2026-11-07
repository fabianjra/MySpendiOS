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
                ? $0.dateCreated > $1.dateCreated
                : $0.dateCreated < $1.dateCreated
            }
            
        /**
         Sorts categories by usage count according to the selected order.
             
         When two categories have the same usage count, the most recently
         used category is displayed first, regardless of the selected order.
         */
        case .usage:
            return sorted {
                if $0.usageCount == $1.usageCount {
                    return $0.dateLastUsed > $1.dateLastUsed
                }
                
                return sort.order == .ascending
                ? $0.usageCount > $1.usageCount
                : $0.usageCount < $1.usageCount
            }
        }
    }
}
