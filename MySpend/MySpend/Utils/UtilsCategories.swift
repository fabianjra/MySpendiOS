//
//  UtilsCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/12/24.
//

import Foundation

struct UtilsCategories {
    
    static func filteredCategories(_ categories: [CategoryModel], by categoryType: TransactionType, sortType: SortCategories? = nil) -> [CategoryModel] {
        
        let filteredList: [CategoryModel] = categories.filter { $0.categoryType == categoryType }
        
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
            }
            
        } else {
            return filteredList
        }
    }
}
