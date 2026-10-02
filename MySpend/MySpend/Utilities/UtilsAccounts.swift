//
//  UtilsAccounts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

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
