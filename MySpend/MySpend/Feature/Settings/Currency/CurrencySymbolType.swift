//
//  CurrencySymbolType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/1/25.
//

import Foundation

enum CurrencySymbolType: String, CaseIterable, Identifiable, Codable {
    public var id: Self { self }
    
    case symbol
    case code
    
    /// Permite obtener el texto localizable para el valor del enum ``CurrencySymbolType``
    var localized: LocalizedStringResource {
        switch self {
        case .symbol: return .currencyPickerSymbol
        case .code: return .currencyPickerCode
        }
    }
}
