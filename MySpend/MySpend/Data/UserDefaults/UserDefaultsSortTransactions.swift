//
//  UserDefaultsSort.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

struct UserDefaultsSortTransactions {
    
    private static let selectedSortTransactionsKey = "selected_sort_transactions_key"
    
    /**
     Sort de transactions almacenado en `UserDefaults`.
     Si no encuentra nada guardado en UserDefaults, utiliza el valor predeterminado.
     */
    static var sortTransactions: SortTransactions {
        get {
            guard let data = UserDefaults.standard.data(forKey: selectedSortTransactionsKey) else { return SortTransactions.byDateNewest }
            
            do {
                return try JSONDecoder().decode(SortTransactions.self, from: data)
            } catch {
                return SortTransactions.byDateNewest
            }
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: selectedSortTransactionsKey)
            }
        }
    }

    static var removeSortTransactions: Void {
        UserDefaults.standard.removeObject(forKey: selectedSortTransactionsKey)
    }
}
