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
    
    private let coreDataManager: AccountCoreDataManager
    private var allAccounts: [AccountModel] = []
    

    // MARK: DEFAULT ACCOUNT
    
    var selectedAccountsToFilterByID = UserDefaultsManager.selectedAccountsFilter {
        didSet { UserDefaultsManager.selectedAccountsFilter = selectedAccountsToFilterByID }
    }
    
    /// Se encarga de setear la cuenta seleccionada por defecto
    func setDefaultAccount(by account: AccountModel) {
        defaultAccountID = account.id.uuidString
    }
    
    /// Cualquiera puede leer su valor, pero solo el código dentro de la misma clase o archivo puede modificarlo.
    private(set) var defaultAccount: AccountModel?
    
    private var defaultAccountID = UserDefaultsManager.defaultAccountID {
        didSet {
            UserDefaultsManager.defaultAccountID = defaultAccountID
            updateDefaultAccount()
        }
    }
    
    private func updateDefaultAccount() {
        guard !defaultAccountID.isEmptyOrWhitespace else {
            defaultAccount = nil
            return
        }
        
        defaultAccount = allAccounts.first {
            $0.id.uuidString == defaultAccountID
        }
    }
    
    
    // MARK: ORDENAMIENTO
    
    var sortedAccounts: [AccountModel] {
        allAccounts.sortedAccounts(by: sortSelection)
    }
    
    var sortSelection = UserDefaultsManager.sortAccounts {
        didSet { UserDefaultsManager.sortAccounts = sortSelection }
    }
    
    func resetSort() {
        sortSelection = AccountSortConfiguration()
    }
    
    
    // MARK: FILTROS
    
    var showOnlyFavorites: Bool = false

    var isFilterActive = UserDefaultsManager.isFilterActive {
        didSet { UserDefaultsManager.isFilterActive = isFilterActive }
    }
    
    func toggleFilter(_ account: AccountModel) {
        if selectedAccountsToFilterByID.contains(account.id) {
            selectedAccountsToFilterByID.remove(account.id)
        } else {
            selectedAccountsToFilterByID.insert(account.id)
        }
    }
    
    /// Limpia las cuentas que podrian haber sido eliminadas del UserDefaults.
    private func cleanFilteredAccounts() {
        let availableIDs = Set(allAccounts.map(\.id))
        selectedAccountsToFilterByID.formIntersection(availableIDs)
    }
    
    func restoreFilter() {
        selectedAccountsToFilterByID = Set(allAccounts.map(\.id))
        showOnlyFavorites = false
    }
    
    
    // MARK: OBSERVABLES
    
    private var viewContextObserver: AnyCancellable?
    private let viewContext: NSManagedObjectContext

    private init() {
        let viewContext = CoreDataUtilities.getViewContext
        self.viewContext = viewContext
        self.coreDataManager = AccountCoreDataManager(viewContext)
        
        Task {
            await refreshAccounts()
        }
        
        startObserveViewContextChanges()
    }
    
    private func refreshAccounts() async {
        do {
            allAccounts = try await coreDataManager.fetchAll()
            
            updateDefaultAccount()
            cleanFilteredAccounts()
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }

    private func startObserveViewContextChanges() {
        guard viewContextObserver == nil else { return } // Evita suscribirse dos veces

        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main) // Evita multiples llamados
            //.receive(on: DispatchQueue.main) // Redundante: Se puede omitir. Con el debounce sobre RunLoop.main ya garantizas que el sink se ejecute en el hilo principal.
            .sink { [weak self] _ in
                
                Task { @MainActor in
                    await self?.refreshAccounts()
                }
            }
    }
    
    
    // MARK: CRUD
    
    func delete(_ account: AccountModel?) async -> ResponseToast {
        guard let account = account else { return ResponseToast()}

        do {
            try await coreDataManager.delete(account)
            return ResponseToast(.responseAccountsDeleted(.zero), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func delete(_ selectedAccounts: Set<AccountModel>) async -> ResponseToast {
        do {
            for item in selectedAccounts {
                try await coreDataManager.delete(item)
            }
            
            return ResponseToast(.responseAccountsDeleted(selectedAccounts.count), .ok)
        } catch {
            Logger.exception(error)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
}
