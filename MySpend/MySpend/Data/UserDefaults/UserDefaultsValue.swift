//
//  UserDefaultsManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

enum UserDefaultsKey: String, Codable {
    
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

struct UserDefaultsValue {
    
    // MARK: SORT TRANSACTIONS
    
    /**
     Gets value stored in `UserDefaults`.
     If there is not data stored, will get a default value
     */
    static var sortTransactions: SortTransactions {
        get {
            return UserDefaultsDataStore<SortTransactions>(for: .sortTransactions).value ?? .byDateNewest
        }
        
        set {
            var manager = UserDefaultsDataStore<SortTransactions>(for: .sortTransactions)
            manager.value = newValue
        }
    }
    
    static var removeSortTransactions: Void {
        UserDefaultsDataStore<SortTransactions>(for: .sortTransactions).removeValue
    }
    
    // MARK: SORT CATEGORIES
    
    static var sortCategories: SortCategories {
        get {
            return UserDefaultsDataStore<SortCategories>(for: .sortCategories).value ?? .byNameAz
        }
        
        set {
            var manager = UserDefaultsDataStore<SortCategories>(for: .sortCategories)
            manager.value = newValue
        }
    }
    
    static var removeSortCategories: Void {
        UserDefaultsDataStore<SortCategories>(for: .sortCategories).removeValue
    }
    
    // MARK: DATE TIME INTERVAL
    
    static var dateTimeInterval: DateTimeInterval {
        get {
            return UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval).value ?? .month
        }
        
        set {
            var manager = UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval)
            manager.value = newValue
        }
    }
    
    static var removeDateTimeInterval: Void {
        UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval).removeValue
    }
    
    // MARK: CURRENCY
    
    static var currency: CurrencyModel {
        get {
            return UserDefaultsDataStore<CurrencyModel>(for: .currency).value ?? CurrencyManager.localeCurrencyOrDefault
        }
        
        set {
            var manager = UserDefaultsDataStore<CurrencyModel>(for: .currency)
            manager.value = newValue
        }
    }
    
    static var removeCurrency: Void {
        UserDefaultsDataStore<CurrencyModel>(for: .currency).removeValue
    }
    
    // MARK: CURRENCY SYMBOL TYPE
    
    static var currencySymbolType: CurrencySymbolType {
        get {
            return UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType).value ?? .symbol
        }
        
        set {
            var manager = UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType)
            manager.value = newValue
        }
    }
    
    static var removeCurrencySymbolType: Void {
        UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType).removeValue
    }
}

fileprivate struct UserDefaultsDataStore<T: Codable> {
    private let key: UserDefaultsKey

    init(for key: UserDefaultsKey) {
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

    /**
     Deletes the stored value in `UserDefaults` for the selected key.
     */
    var removeValue: Void {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
