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
    private static let defaultCurrency = CurrencyModel(countryCode: "US",
                                                       symbol: "$",
                                                       currencyCode: "USD",
                                                       countryName: "United States",
                                                       countryFlag: "🇺🇸")
    
    private static let commonCurrencies = [
        "USD",
        "EUR",
        "JPY",
        "GBP"
    ]
    
    private static let availableCurrencies: [String: String] = [
        "USD": "US", // United States
        "EUR": "ES", // Spain
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
    public static let fractionLength = 2
    
    public static var localDecimalSeparator: String {
        return Locale.current.decimalSeparator ?? "."
    }

    public static var localGroupingSeparator: String {
        return Locale.current.groupingSeparator ?? ","
    }
}

// MARK: - FUNCTIONS

extension CurrencyManager {
    
    /**
     Returns the currency associated with the user's current locale.
     If the region or currency information cannot be determined,
     the default currency (USD) is returned.
     */
    static var localeCurrencyOrDefault: CurrencyModel {
        let locale = Locale.current
        
        guard let region = locale.region?.identifier,
              let currencyCode = locale.currency?.identifier,
              let currencySymbol = locale.currencySymbol else {
            return defaultCurrency
        }
        
        return CurrencyModel(countryCode: region,
                             symbol: currencySymbol,
                             currencyCode: currencyCode,
                             countryName: locale.localizedString(forRegionCode: region) ?? region,
                             countryFlag: region.flagEmoji ?? "🏳️")
    }
    
    
    static func commonCurrencies(from currencies: [CurrencyModel], localCurrency: CurrencyModel) -> [CurrencyModel] {
        [localCurrency] + commonCurrencies.compactMap { code in
            guard code != localCurrency.currencyCode else { return nil }
            return currencies.first { $0.currencyCode == code }
        }
    }
    
    /**
     Returns the list of currencies supported by the application.
     
     Creates a `CurrencyModel` for each currency and region defined in `currencyRegionCodes`.
     Currency information, such as the localized country name and currency symbol, is obtained from the region's `Locale`.
     
     If a custom symbol is available through `getSymbolForCurrencyCode(code:)`,
     it is used instead of the symbol provided by the locale.
     
     The resulting list is sorted alphabetically by currency code.
     
     - Returns: An array of supported `CurrencyModel` values sorted by currency code.
     */
    static let currencyList: [CurrencyModel] = {
        availableCurrencies.compactMap { currencyCode, regionCode -> CurrencyModel? in
            
            let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode])
            let locale = Locale(identifier: localeIdentifier)
            
            guard let currencySymbol = locale.currencySymbol else { return nil }
            
            let customSymbol = symbolForCurrencyCode(code: currencyCode)
            
            return CurrencyModel(countryCode: regionCode,
                                 symbol: customSymbol.isEmptyOrWhitespace ? currencySymbol : customSymbol,
                                 currencyCode: currencyCode,
                                 countryName: locale.localizedString(forRegionCode: regionCode) ?? regionCode,
                                 countryFlag: regionCode.flagEmoji ?? "🏳️")
        }
        .sorted { $0.countryName.localizedStandardCompare($1.countryName) == .orderedAscending }
    }()
    
    // MARK: ONLY FOR SYMBOL:
    
    private static func symbolForCurrencyCode(code: String) -> String {
        let symbols = NSLocale.availableLocaleIdentifiers.compactMap { localeID -> String? in
            let locale = Locale(identifier: localeID)

            guard locale.currency?.identifier == code else { return nil }

            return locale.currencySymbol
        }

        return symbols.first(where: { $0.count == 1 }) ?? symbols.min(by: { $0.count < $1.count }) ?? ""
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
    public static var selectedSymbolOrCode: String {
        switch UserDefaultsManager.currencySymbolType {
        case .symbol: return UserDefaultsManager.currency.symbol
        case .code: return UserDefaultsManager.currency.currencyCode
        }
    }
}
