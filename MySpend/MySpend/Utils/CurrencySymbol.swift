//
//  CurrencySymbol.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

class CurrencySymbol {
    static let shared = CurrencySymbol()
    
    var description: Symbol = .dollar //TODO: Agregar a UserDefaults Y Shared class.
    
    public enum Symbol: String {
        case dollar = "$"
        case colon = "₡"
    }
}
