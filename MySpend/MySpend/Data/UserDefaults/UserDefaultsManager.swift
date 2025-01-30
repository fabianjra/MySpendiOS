//
//  UserDefaultsManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

enum UserDefaultsManager: String, Codable {
    
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
    
    func getValue<T>() -> T {
        switch self {
        case .sortTransactions: return (UserDefaultsDataStore<SortTransactions>(for: .sortTransactions).value ?? .byDateNewest) as! T
        case .sortCategories: return (UserDefaultsDataStore<SortCategories>(for: .sortCategories).value ?? .byNameAz) as! T
        case .dateTimeInterval: return (UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval).value ?? .month) as! T
        case .currency: return (UserDefaultsDataStore<CurrencyModel>(for: .currency).value ?? CurrencyManager.localeCurrencyOrDefault) as! T
        case .currencySymbolType: return (UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType).value ?? .symbol) as! T
        }
    }
    
    func setValue<T>(_ newValue: T) {
        switch self {
        case .sortTransactions:
            var manager = UserDefaultsDataStore<SortTransactions>(for: .sortTransactions)
            manager.value = newValue as? SortTransactions
            
        case .sortCategories:
            var manager = UserDefaultsDataStore<SortCategories>(for: .sortCategories)
            manager.value = newValue as? SortCategories
            
        case .dateTimeInterval:
            var manager = UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval)
            manager.value = newValue as? DateTimeInterval
            
        case .currency:
            var manager = UserDefaultsDataStore<CurrencyModel>(for: .currency)
            manager.value = newValue as? CurrencyModel
            
            
        case .currencySymbolType:
            var manager = UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType)
            manager.value = newValue as? CurrencySymbolType
        }
    }
    
    /**
     Deletes the stored value in `UserDefaults` for the selected key.
     */
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}

private struct UserDefaultsDataStore<T: Codable> {
    private let key: UserDefaultsManager
    
    init(for key: UserDefaultsManager) {
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
