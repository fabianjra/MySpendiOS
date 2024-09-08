//
//  NewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

//TODO: Cambiar nombre a transaccion. Se debe dejar de uasr TransactionModel y utilizar solo esta.
//TODO: Sacar variables que no le pertenecen a la transaccion, como por ejemplo ShowDatePicker y pasarlo al ViewModel.
struct NewTransaction {
    var transactionType: TransactionTypeEnum = .expense
    
    var dateString: String = ""
    var selectedDate: Date = .now
    
    var amount: String = ""
    var categoryId: String = ""
    var notes: String = ""

    enum Field: Hashable {
        case amount
        case category
        case notes
    }
}
