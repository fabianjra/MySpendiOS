//
//  UserDefaultsDate.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

struct UserDefaultsDate {
    
    /**
     Currency almacenado en `UserDefaults`.
     Si no encuentra nada guardado en UserDefaults, utiliza el valor de "MES" como predeterminado.
     */
    static var dateTimeInterval: DateTimeInterval {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.dateTimeInterval.rawValue) else { return DateTimeInterval.month }
            
            do {
                return try JSONDecoder().decode(DateTimeInterval.self, from: data)
            } catch {
                return DateTimeInterval.month
            }
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKey.dateTimeInterval.rawValue)
            }
        }
    }

    static var removeDateTimeInterval: Void {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.dateTimeInterval.rawValue)
    }
}
