//
//  UtilsCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/12/24.
//

import Foundation

struct UtilsCategories {
    
    static func filteredCategories(_ categories: [CategoryModel], by categoryType: CategoryType, sortType: SortCategories? = nil) -> [CategoryModel] {
        
        let filteredList = categories.filter { $0.type == categoryType }
        
        if let sortType = sortType {
            
            switch sortType {
            case .byNameAz:
                return filteredList.sorted(by: { $0.name < $1.name })
                
            case .byNameZa:
                return filteredList.sorted(by: { $0.name > $1.name })
                
            case .byCreationNewest:
                return filteredList.sorted(by: { $0.dateCreated > $1.dateCreated })
                
            case .byCreationOldest:
                return filteredList.sorted(by: { $0.dateCreated < $1.dateCreated })
                
            case .byMostOftenUsed:
                return filteredList.sorted {
                    if $0.usageCount != $1.usageCount {
                        return $0.usageCount > $1.usageCount // Ordering by usage
                    } else {
                        return $0.dateCreated > $1.dateCreated // If categories comparison have same counter, then order by creation date.
                    }
                }
            }
            
        } else {
            return filteredList
        }
    }
}
