//
//  UserDefaultsManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

// MARK: GENERAL

struct UserDefaultsManager {
    
    //static var shared: UserDefaultsManager = UserDefaultsManager()
    
    static var userDefaults: UserDefaults = .standard
    
    static func removeValue(for key: UserDefaultsKeys) {
        UserDefaultsManager.userDefaults.removeObject(forKey: key.rawValue)
    }
    
    static func removeAll() {
        for key in UserDefaultsKeys.allCases {
            removeValue(for: key)
        }
    }
}


// MARK: SORT

extension UserDefaultsManager {
    
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
    
    static var sortAccounts: SortAccounts {
        get { return UserDefaultsDataStore<SortAccounts>(for: .sortAccounts).value ?? .byNameAz }
        set {
            var manager = UserDefaultsDataStore<SortAccounts>(for: .sortAccounts)
            manager.value = newValue
        }
    }
}


// MARK: PREFERENCE

extension UserDefaultsManager {
    
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
}


// MARK: USER DATA

extension UserDefaultsManager {
    
    static var isOnBoarding: Bool {
        get { return UserDefaultsDataStore<Bool>(for: .isOnBoarding).value ?? true }
        set {
            var manager = UserDefaultsDataStore<Bool>(for: .isOnBoarding)
            manager.value = newValue
        }
    }
    
    static var userName: String {
        get { return UserDefaultsDataStore<String>(for: .username).value ?? "" }
        set {
            var manager = UserDefaultsDataStore<String>(for: .username)
            manager.value = newValue
        }
    }
    
    static var userEmail: String {
        get { return UserDefaultsDataStore<String>(for: .userEmail).value ?? "" }
        set {
            var manager = UserDefaultsDataStore<String>(for: .userEmail)
            manager.value = newValue
        }
    }
    
    static var defaultAccountID: String {
        get { return UserDefaultsDataStore<String>(for: .defaultAccountID).value ?? "" }
        set {
            var manager = UserDefaultsDataStore<String>(for: .defaultAccountID)
            manager.value = newValue
        }
    }
}

enum UserDefaultsKeys: String, Codable, CaseIterable {
    
    // MARK: SORT
    case sortTransactions = "sort_transactions_key"
    case sortCategories = "sort_categories_key"
    case sortAccounts = "sort_accounts_key"
    
    // MARK: PREFERENCE
    case dateTimeInterval = "datetime_interval_key"
    case currency = "currency_key"
    case currencySymbolType = "currency_symbol_type_key"
    
    // MARK: USER DATA
    case isOnBoarding = "is_on_boarding_key"
    case username = "user_name_key"
    case userEmail = "user_email_key"
    case defaultAccountID = "default_account_id_key"
    
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
            guard let data = UserDefaultsManager.userDefaults.data(forKey: key.rawValue) else { return nil }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                Logger.exception(error)
                return nil
            }
        }
        
        set {
            guard let newValue = newValue else { return }
            
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaultsManager.userDefaults.set(data, forKey: key.rawValue)
            } catch {
                Logger.exception(error)
            }
        }
    }
}
