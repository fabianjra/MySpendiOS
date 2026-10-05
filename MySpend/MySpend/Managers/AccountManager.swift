//
//  AccountManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/8/26.
//

import CoreData
import Combine

@MainActor
@Observable
final class AccountManager {
    static let shared = AccountManager()

    // MARK: CUENTAS
    
    private var allAccounts: [AccountModel] = []
    
    var sortedAccounts: [AccountModel] {
        allAccounts.sortedAccounts(by: sortingSelected)
    }
    
    var filteredAccounts = UserDefaultsManager.selectedAccountsFilter {
        didSet { UserDefaultsManager.selectedAccountsFilter = selectedAccountsFilter }
    }
    
    var defaultSelected: AccountModel? {
        let defaultID = UserDefaultsManager.defaultAccountID //TODO: Probar si se actualiza, porque no está siendo observada.
        guard defaultID.isEmptyOrWhitespace == false else { return nil }
        return allAccounts.first { $0.id.uuidString == defaultID }
    }
    
    
    // MARK: ORDENAMIENTO
    
    var sortingSelected = UserDefaultsManager.sortAccounts {
        didSet { UserDefaultsManager.sortAccounts = sortSelection }
    }
    
    func resetSort() {
        sortingSelected = AccountSortConfiguration()
    }
    
    
    // MARK: FILTROS
    
    var showOnlyFavorites: Bool = false

    var isFilterActive = UserDefaultsManager.isFilterActive {
        didSet { UserDefaultsManager.isFilterActive = isFilterActive }
    }
    
    func toggleFilter(_ account: AccountModel) {
        if filteredAccounts.contains(account.id) {
            filteredAccounts.remove(account.id)
        } else {
            filteredAccounts.insert(account.id)
        }
    }
    
    func restoreFilter() {
        filteredAccounts = Set(allAccounts.map(\.id))
        showOnlyFavorites = false
    }
    
    
    // MARK: OBSERVABLES
    
    private var viewContextObserver: AnyCancellable?
    private let viewContext: NSManagedObjectContext

    private init() {
        self.viewContext = CoreDataUtilities.getViewContext
        
        // Cargar inicialmente las cuentas
        Task {
            do {
                allAccounts = try await AccountCoreDataManager(viewContext).fetchAll()
            } catch {
                Logger.exception(error, type: .CoreData)
            }
        }
        
        startObserveViewContextChanges()
    }

    private func startObserveViewContextChanges() {
        guard viewContextObserver == nil else { return } // Evita suscribirse dos veces

        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main) // opcional, para evitar multiples llamados
            //.receive(on: DispatchQueue.main) // Redundante: Puedes omitir .receive(on: DispatchQueue.main); con el debounce sobre RunLoop.main ya garantizas que el sink se ejecute en el hilo principal.
            .sink { [weak self] _ in
                
                Task { @MainActor in
                    await self?.onChangeAccounts()
                }
            }
    }
    
    private func onChangeAccounts() async {
        do {
            allAccounts = try await AccountCoreDataManager(viewContext).fetchAll()
            
            // Limpia las cuentas que podrian haber sido eliminadas del UserDefaults.
            let availableIDs = Set(allAccounts.map(\.id))
            filteredAccounts = filteredAccounts.intersection(availableIDs)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    
    // MARK: CRUD
    
    func delete(_ account: AccountModel?) async -> ResponseToast {
        guard let account = account else { return ResponseToast()}

        do {
            try await AccountCoreDataManager(viewContext).delete(account)
            return ResponseToast(.responseAccountsDeleted(.zero), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func deleteMltipleItems(_ selectedAccounts: Set<AccountModel>) async -> ResponseToast {

        do {
            for item in selectedAccounts {
                try await AccountCoreDataManager(viewContext).delete(item)
            }
            
            return ResponseToast(.responseAccountsDeleted(selectedAccounts.count), .ok)
        } catch {
            Logger.exception(error)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
}
