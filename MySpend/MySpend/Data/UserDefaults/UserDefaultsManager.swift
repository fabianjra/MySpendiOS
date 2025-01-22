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

struct UserDefaultsManager<T: Codable> {
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
