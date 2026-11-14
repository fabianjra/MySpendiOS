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
             
             When usage counts are equal, the most recently used category comes first.
             Categories that have never been used are placed after used categories.
             When both categories have never been used, the oldest category comes first.
             */
        case .usage:
            return sorted {
                let isAscending = sort.order == .ascending
                
                if $0.usageCount != $1.usageCount {
                    return isAscending
                    ? $0.usageCount > $1.usageCount
                    : $0.usageCount < $1.usageCount
                }
                
                switch ($0.dateLastUsed, $1.dateLastUsed) {
                case let (date1?, date2?):
                    return isAscending ? date1 > date2 : date1 < date2
                    
                case (.some, .none):
                    return isAscending
                    
                case (.none, .some):
                    return !isAscending
                    
                case (.none, .none):
                    return isAscending
                    ? $0.dateCreated < $1.dateCreated
                    : $0.dateCreated > $1.dateCreated
                }
            }
        }
    }
}
