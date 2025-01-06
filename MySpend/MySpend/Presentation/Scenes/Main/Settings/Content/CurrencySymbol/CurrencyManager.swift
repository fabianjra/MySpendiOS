//
//  CurrencyManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

// MARK: CONSTANTS

public struct CurrencyManager {
    
    // MARK: PRIVATE
    private static let defaultCurrencySymbol: String = "$"
    private static let currencyKey = "selected_region_code"
    
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
    
    private static var defaultLocaleCurrent: String {
        return Locale(identifier: Locale.current.identifier).currencySymbol ?? defaultCurrencySymbol
    }
    
    /// Código de moneda almacenado en `UserDefaults`.
    /// Si no encuentra nada guardado en UserDefaults, utiliza el código de moneda predeterminado basado en la configuración local.
    static var getSelectedSymbol: String {
        get {
            UserDefaults.standard.string(forKey: currencyKey) ?? defaultLocaleCurrent
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: currencyKey)
        }
    }

    static func currencyList(useCurrencyCode: Bool = false) -> [CurrencyModel]{
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
                
                var symbol: String = ""
                
                if useCurrencyCode {
                    symbol = currencyCode
                } else {
                    symbol = getSymbolForCurrencyCode(code: currencyCode)
                    
                    if symbol.isEmptyOrWhitespace {
                        symbol = currencySymbol
                    }
                }
                
                let model = CurrencyModel(countryCode: regionCode,
                                          currencySymbol: symbol,
                                          currencyCode: currencyCode,
                                          countryName: countryName)
                currencyList.append(model)
            }
        }
        
        currencyList.sort { $0.countryName < $1.countryName }
        
        return currencyList
    }
    
    // MARK: ONLY FOR SYMBOL:
    
    private static func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        
        let sorted = sortAscByLength(list: candidates)
        
        if sorted.count < 1 {
            return ""
        }
        
        return sorted[.zero]
    }

    private static func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID)
        
        guard let code = locale.currency?.identifier else {
            return nil
        }
        
        if code != currencyCode {
            return nil
        }
        
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        
        return symbol
    }

    private static func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
}
