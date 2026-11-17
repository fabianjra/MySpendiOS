//
//  CurrencyConstant.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/11/26.
//

import Foundation

struct CurrencyConstant {
    
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
    
    static let amoutMaxLength = 50
    static let fractionLength = 2
    
    static var localDecimalSeparator: String {
        return Locale.current.decimalSeparator ?? "."
    }

    static var localGroupingSeparator: String {
        return Locale.current.groupingSeparator ?? ","
    }
    
    
    /**
     Returns the currency associated with the user's current locale.
     If the region or currency information cannot be determined,
     the default currency (USD) is returned.
     */
    static var localeCurrency: CurrencyModel {
        let locale = Locale.current
        
        guard let region = locale.region?.identifier,
              let currencyCode = locale.currency?.identifier,
              let currencySymbol = locale.currencySymbol else {
            
            // Returns the default Currency in case don't found the locale.
            return CurrencyModel(countryCode: "US",
                                 symbol: "$",
                                 currencyCode: "USD",
                                 countryName: "United States",
                                 countryFlag: "🇺🇸")
        }
        
        return CurrencyModel(countryCode: region,
                             symbol: currencySymbol,
                             currencyCode: currencyCode,
                             countryName: locale.localizedString(forRegionCode: region) ?? region,
                             countryFlag: region.flagEmoji ?? "🏳️")
    }
    
    
    // MARK: - PROPIEDAES PARA LA VISTA CURRENCYVIEW
    
    static let commonCurrencyList: [CurrencyModel] = {
        let localCurrency = localeCurrency
        
        return [localCurrency] + commonCurrencies.compactMap { code in
            guard code != localCurrency.currencyCode else { return nil }
            return availableCurrencyList.first { $0.currencyCode == code }
        }
    }()
    
    /**
     Returns the list of currencies supported by the application.
     
     Creates a `CurrencyModel` for each currency and region defined in `currencyRegionCodes`.
     Currency information, such as the localized country name and currency symbol, is obtained from the region's `Locale`.
     
     If a custom symbol is available through `getSymbolForCurrencyCode(code:)`,
     it is used instead of the symbol provided by the locale.
     
     The resulting list is sorted alphabetically by currency code.
     
     - Returns: An array of supported `CurrencyModel` values sorted by currency code.
     */
    static let availableCurrencyList: [CurrencyModel] = {
        availableCurrencies.compactMap { currencyCode, regionCode -> CurrencyModel? in
            
            let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode])
            let locale = Locale(identifier: localeIdentifier)
            
            guard let currencySymbol = locale.currencySymbol else { return nil }
            
            let customSymbol = symbolForCurrencyCode(code: currencyCode)
            
            return CurrencyModel(countryCode: regionCode,
                                 symbol: customSymbol.isEmptyOrWhiteSpace ? currencySymbol : customSymbol,
                                 currencyCode: currencyCode,
                                 countryName: locale.localizedString(forRegionCode: regionCode) ?? regionCode,
                                 countryFlag: regionCode.flagEmoji ?? "🏳️")
        }
        .sorted { $0.countryName.localizedStandardCompare($1.countryName) == .orderedAscending }
    }()
    
    /// Get the symbol for the currency Code.
    private static func symbolForCurrencyCode(code: String) -> String {
        let symbols = NSLocale.availableLocaleIdentifiers.compactMap { localeID -> String? in
            let locale = Locale(identifier: localeID)

            guard locale.currency?.identifier == code else { return nil }

            return locale.currencySymbol
        }

        return symbols.first(where: { $0.count == 1 }) ?? symbols.min(by: { $0.count < $1.count }) ?? ""
    }
    
    /**
     Returns a localized `NumberFormatter` configured for decimal numbers based on the current locale.
     
     This formatter can be used to format numbers that include a fixed number of fractional digits (like currency).
     
     **Example:**
     ```swift
     let formatter = UtilCurrency.localFormatter
     let formattedNumber = formatter.number(from: "1234.567")
     print(formattedNumber) // Prints "1234.57" or "1234,57" depending on locale
     ```
     
     - Returns: A NumberFormatter configured with locale settings, decimal number style, and rounding mode
     
     - Authors: Fabian Rodriguez
     
     - Date: Sepember 2024
     */
    static func localFormatter(showCents: Bool) -> NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale.current
        //formatter.maximumIntegerDigits = CurrencyConstant.amoutMaxLength
        //formatter.minimumFractionDigits = CurrencyConstant.fractionLength
        formatter.minimumFractionDigits = .zero
        formatter.maximumFractionDigits = showCents ? fractionLength : .zero
        
        /*
         numberStyle: Define el estilo general del formateo numérico.
         .decimal: Formato decimal estándar (ejemplo: 1234.56).
         .currency: Formato monetario (ejemplo: $1,234.56).
         .percent: Formato de porcentaje (ejemplo: 12.34%).
         .scientific: Notación científica (ejemplo: 1.23E3).
         .spellOut: Convierte el número en palabras (ejemplo: "mil doscientos treinta y cuatro").
         */
        //formatter.numberStyle = .decimal
        
        
        // **********************
        // Optionals parameters:
        // **********************
        
        //formateará el número con separadores de miles (ejemplo: 1,234.56)
        formatter.usesGroupingSeparator = true
        
        /*
         roundingMode: Define cómo redondear los números.
         .up: Siempre redondea hacia arriba.
         .down: Siempre redondea hacia abajo.
         .halfUp: Redondea al número más cercano, y si es exactamente a la mitad, redondea hacia arriba (esto es lo estándar en la mayoría de los casos).
         .halfDown: Redondea hacia abajo si está en la mitad.
         .ceiling: Siempre redondea hacia el infinito positivo.
         .floor: Siempre redondea hacia el infinito negativo.
         */
        ///formatter.roundingMode = .halfUp
        
        /*
         currencySymbol y currencyCode: Personaliza el símbolo y el código de la moneda.
         Ejemplo: formatter.currencySymbol = "€" o formatter.currencyCode = "EUR".
         */
        ///formatter.currencySymbol = "$"
        ///formatter.currencyCode = "USD"
        
        /*
         notANumberSymbol: Define lo que se mostrará si el número es un valor no numérico (NaN).
         Ejemplo: formatter.notANumberSymbol = "NaN"
         */
        ///formatter.notANumberSymbol = "NaN"
        
        /*
         positivePrefix y negativePrefix: Establecen un prefijo para números positivos o negativos.
         Ejemplo: formatter.positivePrefix = "+" para que los números positivos tengan un "+" al principio.
         */
        ///formatter.positivePrefix = "+"
        
        return formatter
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
