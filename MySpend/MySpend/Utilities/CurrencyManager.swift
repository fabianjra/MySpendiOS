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
    private static let defaultCountryCode = "US"
    private static let defaultCurrencySymbol = "$"
    private static let defaultCurrencyCode = "USD"
    private static let defaultCountryName = "United States"
    private static let defaultCountryFlag = "🇺🇸"

    private static let defaultDecimalSeparator = "."
    private static let defaultGroupingSeparator = ","
    
    private static let currencyRegionCodes: [String: String] = [
        "USD": "US", // United States
        "EUR": "DE", // Germany
        "JPY": "JP", // Japan
        "GBP": "GB", // United Kingdom
        "CNY": "CN", // China
        "CHF": "CH", // Switzerland
        "AUD": "AU", // Australia
        "CAD": "CA", // Canada
        "HKD": "HK", // Hong Kong
        "SGD": "SG", // Singapore
        "INR": "IN", // India
        "KRW": "KR", // South Korea
        "MXN": "MX", // Mexico
        "BRL": "BR", // Brazil
        "NZD": "NZ", // New Zealand
        "SEK": "SE", // Sweden
        "NOK": "NO", // Norway
        "TWD": "TW", // Taiwan
        "ZAR": "ZA", // South Africa
        "PLN": "PL", // Poland

        // Latin America
        "ARS": "AR", // Argentina
        "BOB": "BO", // Bolivia
        "CLP": "CL", // Chile
        "COP": "CO", // Colombia
        "CRC": "CR", // Costa Rica
        "CUP": "CU", // Cuba
        "DOP": "DO", // Dominican Republic
        "GTQ": "GT", // Guatemala
        "HNL": "HN", // Honduras
        "NIO": "NI", // Nicaragua
        "PAB": "PA", // Panama
        "PYG": "PY", // Paraguay
        "PEN": "PE", // Peru
        "UYU": "UY", // Uruguay
        "VES": "VE"  // Venezuela
    ]
    
    // MARK: PUBLIC
    
    public static let amoutMaxLength = 50
    public static let amoutMaxLengthWithDecimal = 53
    public static let fractionLength = 2
    public static let zeroAmoutString = Int.zero.description
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
                                     countryName: countryName,
                                     countryFlag: region.identifier.flagEmoji ?? "🏳️")
            }
        }
        
        return CurrencyModel(countryCode: CurrencyManager.defaultCountryCode,
                             symbol: CurrencyManager.defaultCurrencySymbol,
                             currencyCode: CurrencyManager.defaultCurrencyCode,
                             countryName: CurrencyManager.defaultCountryName,
                             countryFlag: CurrencyManager.defaultCountryFlag)
    }
    
    /**
     Este metodo consulta todas las monedas disponibles en iOS por cada pais.
     El problema es que duplica las divisas, por ejemplo existe el EURO para España, Andorra, Francia, Alemania, etc.
     No se quiere tener varios paises con la misma moneda, sino, una sola que se usa en muchos paises.
     */
    /*
    private func currencyList() -> [CurrencyModel] {
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
                                          countryName: countryName,
                                          countryFlag: regionCode.flagEmoji ?? "🏳️")
                currencyList.append(model)
            }
        }
        
        currencyList.sort { $0.countryName < $1.countryName }
        
        return currencyList
    }
     */
    
    /**
     Returns the list of currencies supported by the application.
     
     Creates a `CurrencyModel` for each currency and region defined in `currencyRegionCodes`.
     Currency information, such as the localized country name and currency symbol, is obtained from the region's `Locale`.
     
     If a custom symbol is available through `getSymbolForCurrencyCode(code:)`,
     it is used instead of the symbol provided by the locale.
     
     The resulting list is sorted alphabetically by currency code.
     
     - Returns: An array of supported `CurrencyModel` values sorted by currency code.
     */
    static func currencyList() -> [CurrencyModel] {
        
        var currencyList: [CurrencyModel] = []
        
        for (currencyCode, regionCode) in currencyRegionCodes {
            let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode])

            let locale = Locale(identifier: localeIdentifier)

            guard let currencySymbol = locale.currencySymbol else {
                continue
            }

            var symbol = getSymbolForCurrencyCode(code: currencyCode)

            if symbol.isEmptyOrWhitespace {
                symbol = currencySymbol
            }

            let countryName = locale.localizedString(forRegionCode: regionCode) ?? regionCode

            let model = CurrencyModel(countryCode: regionCode,
                                      symbol: symbol,
                                      currencyCode: currencyCode,
                                      countryName: countryName,
                                      countryFlag: regionCode.flagEmoji ?? "🏳️")

            currencyList.append(model)
        }

        currencyList.sort { $0.currencyCode < $1.currencyCode }

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

private extension String {
    
    /**
     Convierte un código de país ISO 3166-1 alpha-2 (por ejemplo "CL", "US", "JP")
     en su emoji de bandera correspondiente.
     
     La conversión se realiza mapeando cada letra del código a su símbolo Unicode
     "Regional Indicator Symbol" (🇦-🇿), los cuales al combinarse en pares
     se renderizan automáticamente como la bandera del país.
     
     ```swift
     "CL".flagEmoji // "🇨🇱"
     "US".flagEmoji // "🇺🇸"
     "xx".flagEmoji // nil (no es un código de país válido)
     ```
     
     - Returns: Un `String` con el emoji de la bandera si `self` es un código
     ISO alpha-2 válido (dos letras A-Z, sin distinguir mayúsculas/minúsculas).
     Retorna `nil` si el string no tiene exactamente 2 caracteres o contiene
     algún carácter fuera del rango A-Z.
     */
    var flagEmoji: String? {
        guard self.count == 2 else { return nil }
        
        let base: UInt32 = 127397
        var scalarView = String.UnicodeScalarView()
        
        for scalar in self.uppercased().unicodeScalars {
            guard scalar.value >= 65 && scalar.value <= 90, // A-Z
                  let flagScalar = Unicode.Scalar(base + scalar.value) else {
                return nil
            }
            scalarView.append(flagScalar)
        }
        
        return String(scalarView)
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
        switch UserDefaultsManager.currencySymbolType {
        case .symbol: return UserDefaultsManager.currency.symbol
        case .code: return UserDefaultsManager.currency.currencyCode
        }
    }
}
