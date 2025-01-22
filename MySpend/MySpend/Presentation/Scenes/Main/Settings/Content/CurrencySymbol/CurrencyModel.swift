//
//  CurrencyModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 5/1/25.
//

import Foundation

struct CurrencyModel: Identifiable, Codable {
    let id: String
    
    let countryCode: String
    let symbol: String
    let currencyCode: String
    let countryName: String
    
    let selected: Bool
    
    init(countryCode: String,
         symbol: String,
         currencyCode: String,
         countryName: String,
         selected: Bool = false) {
        
        self.id = UUID().uuidString
        self.countryCode = countryCode
        self.symbol = symbol
        self.currencyCode = currencyCode
        self.countryName = countryName
        self.selected = selected
    }
    
    var updateModelToUserDefaultsSelected: CurrencyModel {
        return CurrencyModel(countryCode: self.countryCode,
                             symbol: self.symbol,
                             currencyCode: self.currencyCode,
                             countryName: self.countryName,
                             selected: CurrencyModel.userDefaultsValue.countryCode == self.countryCode
        )
    }
}


// MARK: USER DEFAUTLS MANAGER:

extension CurrencyModel {
    
    /**
     Gets value stored in `UserDefaults`.
     If there is not data stored, will get a default value
     */
    static var userDefaultsValue: CurrencyModel {
        get {
            return UserDefaultsManager<CurrencyModel>(for: .currency).value ?? CurrencyManager.localeCurrencyOrDefault
        }
        
        set {
            var manager = UserDefaultsManager<CurrencyModel>(for: .currency)
            manager.value = newValue
        }
    }
    
    static var removeUserDefaultsValue: Void {
        UserDefaultsManager<CurrencyModel>(for: .currency).removeValue
    }
}
