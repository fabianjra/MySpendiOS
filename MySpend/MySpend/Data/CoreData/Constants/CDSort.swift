//
//  CDSort.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/6/25.
//

import Foundation

struct CDSort {
    
    // MARK: ACCOUNT
    
    struct AccountEntity {
        static let byName_Type: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Account.name, ascending: true),
                                                             NSSortDescriptor(keyPath: \Account.type, ascending: true)]
    }
    
    // MARK: TRANSACTION
    
    struct TransactionEntity {
        static let byDateTransaction_Amount: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Transaction.dateTransaction, ascending: true),
                                                      NSSortDescriptor(keyPath: \Transaction.amount, ascending: true)]
    }
    
    
    // MARK: CATEGORY
    
    struct CategoryEntity {
        static let byName_DateCreated: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true),
                                          NSSortDescriptor(keyPath: \Category.dateCreated, ascending: true)]
    }
}
