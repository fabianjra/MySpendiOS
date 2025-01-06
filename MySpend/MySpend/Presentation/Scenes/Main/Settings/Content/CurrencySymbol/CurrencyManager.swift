//
//  CurrencyManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

// MARK: CONSTANTS

struct CurrencyManager {
    
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


// MARK: FUNCTIONS

extension CurrencyManager {
    
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
    
    
    static func currencyList() -> [CurrencyModel]{
        var currencyList: [CurrencyModel] = []

        let regionCodes = Locale.Region.isoRegions.filter { $0.subRegions.isEmpty }.map { $0.identifier }
        
        for regionCode in regionCodes {
            
            let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode])
            let locale = Locale(identifier: localeIdentifier)
            
            // Get values for the locale
            if let countryName = locale.localizedString(forRegionCode: regionCode),
               let currencySymbol = locale.currencySymbol,
               let currencyCode = locale.currency?.identifier {
                
                /*
                 El código de moneda XXX representa una moneda no aplicable (Non-transactional currency), lo que significa que no hay una moneda oficial asociada con ese país o región.
                 Por ejemplo: para la Antártida (código de país AQ), no existe una moneda específica, por lo que Locale utiliza el símbolo genérico (¤).
                 */
                if currencySymbol == "¤" || currencyCode == "XXX" {
                    continue
                }
                
                let model = CurrencyModel(countryCode: regionCode,
                                          currencySymbol: currencySymbol,
                                          currencyCode: currencyCode,
                                          countryName: countryName)
                currencyList.append(model)
            }
        }
        
        return currencyList
    }
}
