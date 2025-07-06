//
//  UtilsCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/12/24.
//

import Foundation

struct UtilsCategories {
    
    static func filteredCategories(_ categories: [CategoryModelFB], by categoryType: CategoryType, sortType: SortCategories? = nil) -> [CategoryModelFB] {
        
        let filteredList: [CategoryModelFB] = categories.filter { $0.categoryType == categoryType }
        
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
                    if $0.usedCounter != $1.usedCounter {
                        return $0.usedCounter > $1.usedCounter // Ordering by usage
                    } else {
                        return $0.dateCreated > $1.dateCreated // If categories comapring are same coutner, order by creation date.
                    }
                }
            }
                
                
            } else {
                return filteredList
            }
        }
    }
