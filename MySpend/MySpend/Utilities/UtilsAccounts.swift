//
//  UtilsAccounts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

struct UtilsAccounts {
    
    static func filteredAccounts(_ accounts: [AccountModel], by accountType: AccountType, sortType: SortAccounts? = nil) -> [AccountModel] {
        
        let filteredList = accounts.filter { $0.type == accountType }
        
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
