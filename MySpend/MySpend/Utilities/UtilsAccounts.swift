//
//  UtilsAccounts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

struct UtilsAccounts {
    
    static func filteredAccounts(_ accounts: [AccountModel], sortType: SortAccounts? = nil) -> [AccountModel] {
        
        if let sortType = sortType {
            
            switch sortType {
            case .byNameAz:
                return accounts.sorted(by: { $0.name < $1.name })
                
            case .byNameZa:
                return accounts.sorted(by: { $0.name > $1.name })
                
            case .byCreationNewest:
                return accounts.sorted(by: { $0.dateCreated > $1.dateCreated })
                
            case .byCreationOldest:
                return accounts.sorted(by: { $0.dateCreated < $1.dateCreated })
            }
        } else {
            return accounts
        }
    }
}
