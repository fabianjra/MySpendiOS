//
//  CurrencyManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 20/9/24.
//

import Foundation

// MARK: - CONSTANTS

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
    public static let zeroAmoutString: String = Int.zero.description
}


// MARK: - UTILS

extension CurrencyManager {
    
    public static var getLocalDecimalSeparator: String {
        return Locale.current.decimalSeparator ?? defaultDecimalSeparator
    }

    public static var getLocalGroupingSeparator: String {
        return Locale.current.groupingSeparator ?? defaultGroupingSeparator
    }
}


// MARK: - FUNCTIONS

extension CurrencyManager {

    /**
     Gets the Local Currency.
     If can't get one of the country or currency settings from local, returns the default USA currency.
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


// MARK: - USER DEFAULTS MANAGER

extension CurrencyManager {
    
    /**
     Gets the symbol type selected in the settings (from UserDefaults).
     Depending on the symbol type, it will take the `symbol` or `code` from the currency saved in the UserDefaults.
     
     It is used to show the currency symbol selected for the currency selected in any view that shows amouts (Transactions View, History, View, etc.)
     */
    public static var getSelectedSymbolOrCode: String {
        switch self.selectedCurrencySymbolType {
        case .symbol: return UserDefaultsManager.currency.symbol
        case .code: return UserDefaultsManager.currency.currencyCode
        }
    }
    
    /**
     Gets or updates the selected Currency in settings.
     Eg: USD, CRC, EUR, etc.
     Based on the currency selected, it can know which country, code or symbol is selected.
     */
    static var selectedCurrency: CurrencyModel {
        get { return UserDefaultsManager.currency }
        set { UserDefaultsManager.currency = newValue }
    }
    
    /**
     Gets or updates the selected symbol type in settings (from UserDefaults)
     */
    static var selectedCurrencySymbolType: CurrencySymbolType {
        get { return UserDefaultsManager.currencySymbolType }
        set { UserDefaultsManager.currencySymbolType = newValue }
    }
}
