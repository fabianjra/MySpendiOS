//
//  CurrencySymbolType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/1/25.
//

enum CurrencySymbolType: String, CaseIterable, Identifiable, Codable {
    public var id: Self { self }
    
    case symbol = "Currency Symbol"
    case code = "Currency Code"
}

// MARK: USER DEFAUTLS MANAGER:

extension CurrencySymbolType {
    
    /**
     Gets value stored in `UserDefaults`.
     If there is not data stored, will get a default value
     */
    static var userDefaultsValue: CurrencySymbolType {
        get {
            return UserDefaultsManager<CurrencySymbolType>(for: .currencySymbolType).value ?? .symbol
        }
        
        set {
            var manager = UserDefaultsManager<CurrencySymbolType>(for: .currencySymbolType)
            manager.value = newValue
        }
    }
    
    static var removeUserDefaultsValue: Void {
        UserDefaultsManager<CurrencySymbolType>(for: .currencySymbolType).removeValue
    }
}
