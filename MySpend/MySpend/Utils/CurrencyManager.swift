//
//  CurrencyManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

struct CurrencyManager {
    private static let currencyCodeList: [String] = ["en_US", "es_CR", "en_GB", "EU", "JP", "CN", "AU", "CA"]
    
    private static let currencyKey = "selectedCurrencyCode"

    /// Código de moneda almacenado en `UserDefaults`.
    static var selectedCurrencyCode: String {
        get {
            UserDefaults.standard.string(forKey: currencyKey) ?? defaultCurrencyCode
        }
        set {
            UserDefaults.standard.set(newValue, forKey: currencyKey)
        }
    }
    
    /// Código de moneda predeterminado basado en la configuración local.
    private static var defaultCurrencyCode: String {
        return Locale.current.identifier
    }
    
    /// Obtiene el símbolo de moneda basado en un código de región.
    /// Return: Símbolo de moneda basado en el código seleccionado en `UserDefaults`.
    public static var getSelectedSymbol: String {
        let locale = Locale(identifier: selectedCurrencyCode)
        return locale.currencySymbol ?? selectedCurrencyCode
    }
    
    
    //TODO: IMPLEMENTAR EN LIST:
    
    /// Imprime la lista de regiones y sus símbolos de moneda para depuración.
    static func listCountriesAndCurrencies() {
        let localeIds = Locale.availableIdentifiers
        var countryCurrency = [String: String]()
        
        for localeId in localeIds {
            let locale = Locale(identifier: localeId)
            
            if let region = locale.region?.identifier, region.count == 2 {
                if let currencySymbol = locale.currencySymbol {
                    countryCurrency[region] = currencySymbol
                }
            }
        }
        
        let sortedKeys = countryCurrency.keys.sorted()
        
        for region in sortedKeys {
            if let currency = countryCurrency[region] {
                print("Region: \(region), Currency: \(currency)")
            }
        }
    }
}
