//
//  UserDefaultsManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 19/1/25.
//

import Foundation

struct UserDefaultsManager {
    
    static var userDefaults: UserDefaults {
        UtilsUI.isRunningOnCanvasPreview ? .preview : .standard
    }

    static func removeAll() {
        UserDefaultsKeys.allCases.forEach {
            userDefaults.removeObject(forKey: $0.rawValue)
        }
    }
    
    
    // MARK: - SORT
    
    static var sorTransactions: TransactionSortConfiguration {
        get { return UserDefaultsDataStore<TransactionSortConfiguration>(for: .sortTransactions).value ?? TransactionSortConfiguration() }
        set { UserDefaultsDataStore<TransactionSortConfiguration>(for: .sortTransactions).value = newValue } // No necesitas var porque nonmutating set permite modificar value sin mutar el struct.
    }
    
    static var sortCategories: CategorySortConfiguration {
        get { return UserDefaultsDataStore<CategorySortConfiguration>(for: .sortCategories).value ?? CategorySortConfiguration() }
        set { UserDefaultsDataStore<CategorySortConfiguration>(for: .sortCategories).value = newValue }
    }
    
    static var sortAccounts: AccountSortConfiguration {
        get { return UserDefaultsDataStore<AccountSortConfiguration>(for: .sortAccounts).value ?? AccountSortConfiguration() }
        set { UserDefaultsDataStore<AccountSortConfiguration>(for: .sortAccounts).value = newValue }
    }
    
    
    // MARK: - PREFERENCE
    
    static var dateTimeInterval: DateTimeInterval {
        get { return UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval).value ?? .month }
        set { UserDefaultsDataStore<DateTimeInterval>(for: .dateTimeInterval).value = newValue }
    }
    
    static var currency: CurrencyModel {
        get { return UserDefaultsDataStore<CurrencyModel>(for: .currency).value ?? CurrencyConstant.localeCurrency }
        set { UserDefaultsDataStore<CurrencyModel>(for: .currency).value = newValue }
    }
    
    static var currencySymbolType: CurrencySymbolType {
        get { return UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType).value ?? .symbol }
        set { UserDefaultsDataStore<CurrencySymbolType>(for: .currencySymbolType).value = newValue }
    }
    
    static var appTheme: AppTheme {
        get { return UserDefaultsDataStore<AppTheme>(for: .appTheme).value ?? .system }
        set { UserDefaultsDataStore<AppTheme>(for: .appTheme).value = newValue }
    }
    
    
    // MARK: - USER DATA
    
    static var userName: String {
        get { return UserDefaultsDataStore<String>(for: .username).value ?? "" }
        set { UserDefaultsDataStore<String>(for: .username).value = newValue }
    }
    
    static var userEmail: String {
        get { return UserDefaultsDataStore<String>(for: .userEmail).value ?? "" }
        set { UserDefaultsDataStore<String>(for: .userEmail).value = newValue }
    }
    
    static var userPhone: String {
        get { return UserDefaultsDataStore<String>(for: .userPhone).value ?? "" }
        set { UserDefaultsDataStore<String>(for: .userPhone).value = newValue }
    }
    
    static var defaultAccountID: String {
        get { return UserDefaultsDataStore<String>(for: .defaultAccountID).value ?? "" }
        set { UserDefaultsDataStore<String>(for: .defaultAccountID).value = newValue }
    }
    
    /// Reactivity is handled by TransactionManager through SwiftUI's Environment, so @AppStorage is not required.
    static var selectedAccountsFilter: Set<UUID> {
        get { return UserDefaultsDataStore<Set<UUID>>(for: .selectedAccountsFilter).value ?? [] }
        set { UserDefaultsDataStore<Set<UUID>>(for: .selectedAccountsFilter).value = newValue }
    }
    
    /// Reactivity is handled by TransactionManager through SwiftUI's Environment, so @AppStorage is not required.
    static var isFilterActive: Bool {
        get { return UserDefaultsDataStore<Bool>(for: .isFilterActive).value ?? false }
        set { UserDefaultsDataStore<Bool>(for: .isFilterActive).value = newValue }
    }
}

enum UserDefaultsKeys: String, Codable, CaseIterable {
    
    // MARK: SORT
    case sortTransactions = "sort_transactions_key"
    case sortCategories = "sort_categories_key"
    case sortAccounts = "sort_accounts_key"
    
    // MARK: PREFERENCE
    case dateTimeInterval = "date_interval_key"
    case currency = "currency_key"
    case currencySymbolType = "currency_symbol_type_key"
    case appTheme = "app_theme_key"
    case showCents = "show_cents_key"
    
    // MARK: USER DATA
    case isOnBoarding = "is_on_boarding_key"
    case username = "user_name_key"
    case userEmail = "user_email_key"
    case userPhone = "user_phone_key"
    case defaultAccountID = "default_account_id_key"
    
    // MARK: FILTER
    case selectedAccountsFilter = "selected_account_filter_key"
    case isFilterActive = "is_filter_active_key"
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
                logError(error)
                return nil
            }
        }
        
        /**
         Allows updating UserDefaults without modifying the struct itself.

         `nonmutating` enables setting the value even when the
         UserDefaultsDataStore instance is declared with `let`,
         since changes are applied to external storage.
         */
        nonmutating set {
            guard let newValue else {
                UserDefaultsManager.userDefaults.removeObject(forKey: key.rawValue)
                return
            }
            
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaultsManager.userDefaults.set(data, forKey: key.rawValue)
            } catch {
                logError(error)
            }
        }
    }
    
    private func logError(_ error: Error) {
        let id = UUID().uuidString
        Logger.exception(error, id: id)
        Logger.custom("Key: \(key.rawValue)", id: id)
    }
}


extension UserDefaults {
    static let preview: UserDefaults = {
        let suiteName = "preview.myspend.app"

        guard let suite = UserDefaults(suiteName: suiteName) else {
            //assertionFailure("Unable to create Preview UserDefaults suite") // El programa llegó a un punto que, según mi lógica, nunca debería ocurrir.
            fatalError("Unable to create Preview UserDefaults suite")
        }

        // Borra todos los valores guardados dentro de ese suite, cada vez que se reinicia el Preview Canvas.
        suite.removePersistentDomain(forName: suiteName)

        return suite
    }()
}
