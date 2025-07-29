//
//  AccountType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/7/25.
//

enum AccountType: String, CaseIterable, Hashable, Localizable {
    case general
    case expenses
    case incomes
    
    var allowedCategory: CategoryType? {
        switch self {
        case .expenses:
            return .expense
        case .incomes:
            return .income
        default:
            return nil
        }
    }
    
    var table: String { Tables.enums }
}
