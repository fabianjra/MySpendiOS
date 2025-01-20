//
//  UserDefaultsCurrency.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

struct UserDefaultsCurrency {
    
    /**
     Currency almacenado en `UserDefaults`.
     Si no encuentra nada guardado en UserDefaults, utiliza el código de moneda predeterminado basado en la configuración local.
     */
    static var currency: CurrencyModel {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.currency.rawValue) else { return CurrencyManager.localeCurrencyOrDefault }
            
            do {
                return try JSONDecoder().decode(CurrencyModel.self, from: data)
            } catch {
                return CurrencyManager.localeCurrencyOrDefault
            }
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKey.currency.rawValue)
            }
        }
    }

    static var removeCurrency: Void {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.currency.rawValue)
    }
    
    static var currencySymbolType: CurrencySymbolType {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.currencySymbolType.rawValue) else { return CurrencySymbolType.symbol }
            
            do {
                return try JSONDecoder().decode(CurrencySymbolType.self, from: data)
            } catch {
                return CurrencySymbolType.symbol
            }
        }

        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKey.currencySymbolType.rawValue)
            }
        }
    }
    
    static var removeCurrencySymbolType: Void {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.currencySymbolType.rawValue)
    }
}
