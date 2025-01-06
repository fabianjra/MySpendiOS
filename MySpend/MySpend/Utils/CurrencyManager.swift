//
//  CurrencyManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

struct CurrencyManager {
    
    /// Código de moneda almacenado en `UserDefaults`.
    /// Si no encuentra nada guardado en UserDefaults, utiliza el código de moneda predeterminado basado en la configuración local.
    static var selectedCurrencyCode: String {
        get {
            UserDefaults.standard.string(forKey: currencyKey) ?? Locale.current.identifier
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: currencyKey)
        }
    }
    
    /// Obtiene el símbolo de moneda basado en un código de región.
    /// Return: Símbolo de moneda basado en el código seleccionado en `UserDefaults`.
    public static var getSelectedSymbol: String {
        let locale = Locale(identifier: selectedCurrencyCode)
        return locale.currencySymbol ?? defaultCurrencySymbol
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

// MARK: CONSTANTS

extension CurrencyManager {
    
    // MARK: PRIVATE
    
    private static let currencyCodeList: [String] = ["en_US", "es_CR", "en_GB", "EU", "JP", "CN", "AU", "CA"]
    private static let defaultCurrencySymbol: String = "$"
    private static let currencyKey = "selected_currency_code"
    
    // MARK: PUBLIC
    
    public static let amoutMaxLength: Int = 50
    public static let amoutMaxLengthWithDecimal: Int = 53
    public static let fractionLength: Int = 2
    public static let zeroAmoutString: String = "0"
    
    public static let defaultDecimalSeparator: String = "."
    public static let defaultGroupingSeparator: String = ","
}
