//
//  UtilsAccounts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

//struct UtilsAccounts {
//    
//    static func sortAccounts(_ accounts: [AccountModel], sortType: SortAccounts? = nil) -> [AccountModel] {
//        
//        if let sortType = sortType {
//            
//            switch sortType {
//            case .byNameAz:
//                return accounts.sorted(by: { $0.name < $1.name })
//                
//            case .byNameZa:
//                return accounts.sorted(by: { $0.name > $1.name })
//                
//            case .byCreationNewest:
//                return accounts.sorted(by: { $0.dateCreated > $1.dateCreated })
//                
//            case .byCreationOldest:
//                return accounts.sorted(by: { $0.dateCreated < $1.dateCreated })
//            }
//        } else {
//            return accounts
//        }
//    }
//}

extension Array where Element == AccountModel {
    
    func sortedAccounts(by sortType: SortAccounts?) -> [AccountModel] {
        
        guard let sortType else {
            return self
        }
        
        switch sortType {
            
        case .byNameAz:
            return sorted { $0.name < $1.name }
            
        case .byNameZa:
            return sorted { $0.name > $1.name }
            
        case .byCreationNewest:
            return sorted { $0.dateCreated > $1.dateCreated }
            
        case .byCreationOldest:
            return sorted { $0.dateCreated < $1.dateCreated }
        }
    }
}
