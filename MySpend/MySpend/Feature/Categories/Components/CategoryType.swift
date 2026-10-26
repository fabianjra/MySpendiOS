//
//  CategoryType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/24.
//

import Foundation

enum CategoryType: String, CaseIterable, Identifiable, Codable {
    public var id: Self { self }
    
    case expense
    case income
    
    /// Permite obtener el texto localizable para el valor del enum ``CategoryType``
    var localized: LocalizedStringResource {
        switch self {
        case .expense: return .categoryTypeExpense
        case .income: return .categoryTypeIncome
        }
    }
}
