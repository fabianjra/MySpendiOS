//
//  UserDefaultsManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

enum UserDefaultsKey: String {
    
    // MARK: SORT
    case sortTransactions = "sort_transactions_key"
    case sortCategories = "sort_categories_key"
    
    // MARK: PREFERENCE
    case dateTimeInteval = "datetime_interval_key"
    case currency = "currency_key"
    case currencySymbolType = "currency_symbol_type_key"
}

struct UserDefaultsManager<T: Codable> {
    
    private let key: UserDefaultsKey

    /// Inicializa el gestor con una clave específica para el almacenamiento en `UserDefaults`.
    init(for key: UserDefaultsKey) {
        self.key = key
    }

    /**
     Obtiene el valor almacenado en `UserDefaults` o un valor predeterminado.
     
     - returns: Objeto pasado de donde se quiere obtener el valor del UserDefaults. En caso de error, retorna nil.
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
            if let newValue = newValue {

                do {
                    let encoded = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(encoded, forKey: key.rawValue)
                } catch {
                    Logs.WriteCatchExeption("Error encoding (set) data for key: \(key.rawValue)", error: error)
                }
            }
        }
    }
    
    /**
     Elimina el valor almacenado en `UserDefaults`.
     */
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
