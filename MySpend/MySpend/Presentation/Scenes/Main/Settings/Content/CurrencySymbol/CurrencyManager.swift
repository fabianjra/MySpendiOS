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
    private static let defaultCountryCode: String = "US"
    private static let defaultCurrencySymbol: String = "$"
    private static let defaultCurrencyCode: String = "USD"
    private static let defaultCountryName: String = "United States"

    private static let defaultDecimalSeparator: String = "."
    private static let defaultGroupingSeparator: String = ","
    
    // MARK: PUBLIC
    
    public static let amoutMaxLength: Int = 50
    public static let amoutMaxLengthWithDecimal: Int = 53
    public static let fractionLength: Int = 2
    public static let zeroAmoutString: String = "0"
}


// MARK: UTILS

extension CurrencyManager {
    
    public static var getLocalDecimalSeparator: String {
        return Locale.current.decimalSeparator ?? defaultDecimalSeparator
    }

    public static var getLocalGroupingSeparator: String {
        return Locale.current.groupingSeparator ?? defaultGroupingSeparator
    }
}


// MARK: FUNCTIONS

extension CurrencyManager {

    /**
     Obtiene el Locale Currency. En caso de ser nulo, obtiene los valores de USA por defecto.
     */
    static var localeCurrencyOrDefault: CurrencyModel {
        let locale = Locale(identifier: Locale.current.identifier)
        
        if let region = locale.region {
            
            if let countryName = locale.localizedString(forRegionCode: region.identifier),
               let currencySymbol = locale.currencySymbol,
               let currencyCode = locale.currency?.identifier {
                
                return CurrencyModel(countryCode: region.identifier,
                                     symbol: currencySymbol,
                                     currencyCode: currencyCode,
                                     countryName: countryName)
            }
        }
        
        return CurrencyModel(countryCode: CurrencyManager.defaultCountryCode,
                             symbol: CurrencyManager.defaultCurrencySymbol,
                             currencyCode: CurrencyManager.defaultCurrencyCode,
                             countryName: CurrencyManager.defaultCountryName)
    }
    
    static func currencyList() -> [CurrencyModel] {
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
                
                var symbol = getSymbolForCurrencyCode(code: currencyCode)
                
                if symbol.isEmptyOrWhitespace {
                    symbol = currencySymbol
                }
                
                let model = CurrencyModel(countryCode: regionCode,
                                          symbol: symbol,
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
        
        let sorted = candidates.sorted(by: { $0.count < $1.count })
        
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
}


// MARK: USER DEFAULTS

extension CurrencyManager {
    
    public static var getSelectedSymbolOrCode: String {
        switch CurrencySymbolType.userDefaultsValue {
            
        case .symbol:
            return CurrencyModel.userDefaultsValue.symbol
            
        case .code:
            return CurrencyModel.userDefaultsValue.currencyCode
        }
    }
    
    static var selectedCurrency: CurrencyModel {
        get {
            return CurrencyModel.userDefaultsValue
        }
        
        set {
            CurrencyModel.userDefaultsValue = newValue
        }
    }
    
    static var selectedCurrencySymbolType: CurrencySymbolType {
        get {
            return CurrencySymbolType.userDefaultsValue
        }
        
        set {
            CurrencySymbolType.userDefaultsValue = newValue
        }
    }
}
