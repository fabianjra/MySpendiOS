//
//  AccountType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/7/25.
//

import Foundation

enum AccountType: String, CaseIterable, Hashable {
    case general = "general"
    case expenses = "expenses"
    case incomes = "incomes"
}
