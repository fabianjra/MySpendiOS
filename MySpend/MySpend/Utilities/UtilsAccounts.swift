//
//  UtilsAccounts.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

extension Array where Element == AccountModel {
    
    func sortedAccounts(by sort: AccountSortConfiguration) -> [AccountModel] {
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
        }
    }
}
