//
//  UserDefaultsManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

struct UserDefaultsManager {
    
    static var sorTransactions: SortTransactions {
        get { return UserDefaultsDataStore<SortTransactions>(for: .sortTransactions).value ?? .byDateNewest }
        set {
            var manager = UserDefaultsDataStore<SortTransactions>(for: .sortTransactions)
            manager.value = newValue
        }
    }
    
    static var sorCategories: SortCategories {
        get { return UserDefaultsDataStore<SortCategories>(for: .sortCategories).value ?? .byNameAz }
        set {
            var manager = UserDefaultsDataStore<SortCategories>(for: .sortCategories)
            manager.value = newValue
        }
    }
    
    static var dateTimeInterval: DateTimeInterval {
        get { return UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval).value ?? .month }
        set {
            var manager = UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval)
            manager.value = newValue
        }
    }
    
    static var currency: CurrencyModel {
        get { return UserDefaultsDataStore<CurrencyModel>(for: .currency).value ?? CurrencyManager.localeCurrencyOrDefault }
        set {
            var manager = UserDefaultsDataStore<CurrencyModel>(for: .currency)
            manager.value = newValue
        }
    }
    
    static var currencySymbolType: CurrencySymbolType {
        get { return UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType).value ?? .symbol }
        set {
            var manager = UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType)
            manager.value = newValue
        }
    }
    
    static func removeValue(for key: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    static func removeAll() {
        for key in UserDefaultsKeys.allCases {
            removeValue(for: key)
        }
    }
}

enum UserDefaultsKeys: String, Codable, CaseIterable {
    
    // MARK: SORT
    case sortTransactions = "sort_transactions_key"
    case sortCategories = "sort_categories_key"
    
    // MARK: PREFERENCE
    case dateTimeInterval = "datetime_interval_key"
    case currency = "currency_key"
    case currencySymbolType = "currency_symbol_type_key"
    
//    var valueType: Codable.Type {
//        switch self {
//        case .sortTransactions: return SortTransactions.self
//        case .sortCategories: return SortCategories.self
//        case .dateTimeInterval: return DateTimeInterval.self
//        case .currency: return CurrencyModel.self
//        case .currencySymbolType: return CurrencySymbolType.self
//        }
//    }
}

private struct UserDefaultsDataStore<T: Codable> {
    private let key: UserDefaultsKeys
    
    init(for key: UserDefaultsKeys) {
        self.key = key
    }
    
    /**
     Gets the value stored in `UserDefaults` or `nil` if there is no data.
     */
    var value: T? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                Logs.WriteCatchExeption("Error decoding (get) data for key: \(key.rawValue)", error: error)
                return nil
            }
        }
        
        set {
            guard let newValue = newValue else { return }
            
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key.rawValue)
            } catch {
                Logs.WriteCatchExeption("Error encoding (set) data for key: \(key.rawValue)", error: error)
            }
        }
    }
}
