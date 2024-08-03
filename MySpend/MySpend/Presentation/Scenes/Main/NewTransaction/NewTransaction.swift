//
//  NewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

struct NewTransaction {
    var transactionType: TransactionTypeEnum = .expense
    
    var dateString: String = ""
    var selectedDate: Date = .now
    
    var showDatePicker = false
    
    var amount: String = ""
    var category: String = ""
    var notes: String = ""
    
    var errorMessage: String = ""
    var isLoading: Bool = false
    
    enum Field: Hashable {
        case amount
        case category
        case notes
    }
}
