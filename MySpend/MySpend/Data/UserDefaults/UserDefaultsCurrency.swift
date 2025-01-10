//
//  UserDefaultsCurrency.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

struct UserDefaultsCurrency {
    
    private static let selectedCurrencyKey = "selected_currency_key"
    private static let selectedCurrencySymbolType = "selected_currency_symbol_type_key"
    
    /**
     Currency almacenado en `UserDefaults`.
     Si no encuentra nada guardado en UserDefaults, utiliza el código de moneda predeterminado basado en la configuración local.
     */
    static var selectedCurrencyUserDefaults: CurrencyModel {
        get {
            guard let data = UserDefaults.standard.data(forKey: selectedCurrencyKey) else { return CurrencyManager.localeCurrencyOrDefault }
            
            do {
                return try JSONDecoder().decode(CurrencyModel.self, from: data)
            } catch {
                return CurrencyManager.localeCurrencyOrDefault
            }
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: selectedCurrencyKey)
            }
        }
    }

    static var removeSelectedCurrencyUserDefaults: Void {
        UserDefaults.standard.removeObject(forKey: selectedCurrencyKey)
    }
    
    static var selectedCurrencySymbolTypeUserDefaults: CurrencySymbolType {
        get {
            guard let data = UserDefaults.standard.data(forKey: selectedCurrencySymbolType) else { return CurrencySymbolType.symbol }
            
            do {
                return try JSONDecoder().decode(CurrencySymbolType.self, from: data)
            } catch {
                return CurrencySymbolType.symbol
            }
        }

        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: selectedCurrencySymbolType)
            }
        }
    }
    
    static var removeSelectedCurrencySymbolTypeUserDefaults: Void {
        UserDefaults.standard.removeObject(forKey: selectedCurrencySymbolType)
    }
}
