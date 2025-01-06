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
    
    static func listCountriesAndCurrencies3() {
        
        var currencyList: [CurrencyModel] = []
        let regions = Locale.Region.isoRegions.filter { $0.subRegions.isEmpty }//.map { $0.identifier }
        
        for region in regions {
            
            print("")
            print("--")
            print("")
            
            
            print("Region Code: \(region)")
            
            let locale = Locale(identifier: region.identifier)
            
            print("locale: \(locale)")
            
            if let currencySymbol = locale.currencySymbol {
                
                print("currencySymbol: \(currencySymbol)")
                
                if let countryName = locale.localizedString(forRegionCode: region.identifier) {
                    
                    print("countryName: \(countryName)")
                    
                    if let currencyCode = locale.currency?.identifier {
                        
                        print("currencyCode: \(currencyCode)")
                        
                        let model = CurrencyModel(countryCode: region.identifier,
                                                  currencySymbol: currencySymbol,
                                                  currencyCode: currencyCode,
                                                  countryName: countryName)
                        currencyList.append(model)
                    }
                }
            }
        }
        
        print("Lista:")
        for country in currencyList {
            print("Country: \(country.countryName), Country Code: \(country.countryCode), Currency: \(country.currencySymbol), CurrencyCode: \(country.currencyCode)")
        }
    }
    
    static func numero3() {
        // Obtener todos los códigos de región ISO
        //let countryCodes = Locale.isoRegionCodes
        //let countryCodes = Locale.Region.isoRegions.filter { $0.subRegions.isEmpty }.map { $0.identifier }
        let countryCodes = Locale.Region.isoRegions.filter { $0.subRegions.isEmpty }


        // Imprimir todos los códigos
        for code in countryCodes {
            print("Country Code: \(code)")
        }

        // Opcional: Verificar la cantidad total de códigos
        print("Total Country Codes: \(countryCodes.count)")
    }

    
    /// Imprime la lista de regiones y sus símbolos de moneda para depuración.
    static func listCountriesAndCurrencies() {

        var currencyList: [CurrencyModel] = []
        
        for localeId in Locale.availableIdentifiers {
            let locale = Locale(identifier: localeId)
            
            // Validate if regionID has 2 values (eg: US, CR, MX).
            //if let region = locale.region, region.identifier.count == 2 {
            if let region = locale.region, region.identifier.count == 2 {
                
                    if let currencySymbol = locale.currencySymbol {
                        
                        if let countryName = locale.localizedString(forRegionCode: region.identifier) {
                            
                            if let currencyCode = locale.currency?.identifier {
                                
                                let model = CurrencyModel(countryCode: region.identifier,
                                                          currencySymbol: currencySymbol,
                                                          currencyCode: currencyCode,
                                                          countryName: countryName)
                                currencyList.append(model)
                            }
                            
                        }
                    }
            }
        }
        
        currencyList.sort { $0.countryName < $1.countryName }
        
        for country in currencyList {
            print("Country: \(country.countryName), Country Code: \(country.countryCode), Currency: \(country.currencySymbol), CurrencyCode: \(country.currencyCode)")
        }
    }
    
    static func listCountriesAndCurrencies2() {
        
        //You're assuming that every language group within in region uses the same currency. This happens to be true, but it's not promised (humans are very inconsistent). But it is true, so we can use that fact.
        
        
        //First, let's prove it's currently true so you could detect if it ever weren't true. To do that, create all the locales (this is a technique you'll need later, so it's worth trying out).
        let locales = Locale.availableIdentifiers.map(Locale.init(identifier:))
        
        
        //Now, make a mapping of every region to every currency used in that region:
        let currencies = Dictionary(grouping: locales,
                                    by: { $0.region?.identifier ?? ""})
            .mapValues { $0.compactMap { $0.currency?.identifier }}
        
        //The output of this is in the pattern:
        //["BZ": ["BZD", "BZD"], "MR": ["MRU", "MRU", "MRU", "MRU"], ...
        
        //Then the question is: are there any regions that use more than one currency?
        let allMatch = currencies.values
            .filter { list in !list.allSatisfy { $0 == list.first }}
            .isEmpty  // true
        
        //Good. This assumption seems to work. We can pick any random language within a region that has a currency, and that currency should be the currency for the region.
        
        //Given that it's safe to pick a random language, let's do that:
        let isoCountryCodeGB = "GB"

        let localeGB = Locale.availableIdentifiers.lazy
            .map(Locale.init(identifier:))
            .first(where: { $0.region?.identifier == isoCountryCodeGB && $0.currency != nil })

        localeGB?.currency?.identifier  // "GBP"
        
        //BTW, this happens to pick Cornish (kw) as the language on my machine, not English, but that's fine. The assumption was that any regional language will have the same currency.
    }
}

struct CurrencyModel {
    let countryCode: String
    let currencySymbol: String
    let currencyCode: String
    let countryName: String
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
