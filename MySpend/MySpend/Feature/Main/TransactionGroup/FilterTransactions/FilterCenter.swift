//
//  FilterTransactionsViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/8/26.
//

import CoreData
import Combine

@MainActor
@Observable
final class FilterCenter {
    static let shared = FilterCenter()

    var showOnlyFavorites: Bool = false

    var selectedAccountsFilter = UserDefaultsManager.selectedAccountsFilter {
        didSet { UserDefaultsManager.selectedAccountsFilter = selectedAccountsFilter }
    }

    var isFilterActive = UserDefaultsManager.isFilterActive {
        didSet { UserDefaultsManager.isFilterActive = isFilterActive }
    }
    
    var allAccounts: [AccountModel] = []

    private var viewContextObserver: AnyCancellable?
    private let viewContext: NSManagedObjectContext

    private init() {
        self.viewContext = CoreDataUtilities.getViewContext
        
        // Cargar inicialmente las cuentas
        Task {
            do {
                allAccounts = try await AccountManager(viewContext).fetchAll()
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
            allAccounts = try await AccountManager(viewContext).fetchAll()
            
            // Limpia las cuentas que podrian haber sido eliminadas del UserDefaults.
            let availableIDs = Set(allAccounts.map(\.id))
            selectedAccountsFilter = selectedAccountsFilter.intersection(availableIDs)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    
    func restoreFilter() {
        selectedAccountsFilter = Set(allAccounts.map(\.id))
        showOnlyFavorites = false
    }

    func toggleAccount(_ account: AccountModel) {
        if selectedAccountsFilter.contains(account.id) {
            selectedAccountsFilter.remove(account.id)
        } else {
            selectedAccountsFilter.insert(account.id)
        }
    }
}
