//
//  AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Combine
import CoreData

@MainActor
@Observable
final class AccountViewModel {
    
    // MARK: EDIT
    var isEditing: Bool = false
    var selectedAccounts = Set<AccountModel>()
    
    // MARK: SORT
    var sortSelection = UserDefaultsManager.sortAccounts {
        didSet {
            UserDefaultsManager.sortAccounts = sortSelection
            allAccounts = allAccounts.sortedAccounts(by: sortSelection)
        }
    }
    
    var allAccounts: [AccountModel] = []
    var accountToDelete: AccountModel?
    var accountToUpdate: AccountModel?
    
    // MARK: DATA ON SCREEN
    var defaultModelSelected: AccountModel? {
        let defaultID = UserDefaultsManager.defaultAccountID
        guard defaultID.isEmptyOrWhitespace == false else { return nil }
        return allAccounts.first { $0.id.uuidString == defaultID }
    }
    

    // MARK: - CORE DATA
    private let viewContext: NSManagedObjectContext
    private var viewContextObserver: AnyCancellable?
    
    init(viewContext: NSManagedObjectContext? = nil) {
        self.viewContext = viewContext ?? CoreDataUtilities.getViewContext

        startObserveViewContextChanges()
    }
    
    private func startObserveViewContextChanges() {
        guard viewContextObserver == nil else { return } // Evita suscribirse dos veces

        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main) // opcional, para evitar multiples llamados
            .sink { [weak self] _ in
                
                Task { @MainActor in
                    await self?.fetchAccounts()
                }
            }
    }
    
    func fetchAccounts() async -> ResponseToast? {
        do {
            allAccounts = try await AccountManager(viewContext)
                .fetchAll()
                .sortedAccounts(by: sortSelection)
            
            return nil
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(.responseErrorFetchAccounts, .error)
        }
    }
    
    public func deactivateObservers() {
        viewContextObserver?.cancel()
        viewContextObserver = nil
    }
    

    func toggleAccountSelection(_ account: AccountModel) {
        if selectedAccounts.contains(account) {
            selectedAccounts.remove(account)
        } else {
            selectedAccounts.insert(account)
        }
    }
    
    func delete() async -> ResponseToast {
        guard let accountToUpdate = accountToDelete else { return ResponseToast()}
        
        defer {
            self.accountToDelete = nil
        }
        
        do {
            try await AccountManager(viewContext).delete(accountToUpdate)
            return ResponseToast(.responseAccountsDeleted(.zero), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func deleteMltipleItems() async -> ResponseToast {
        defer {
            isEditing = false
            selectedAccounts.removeAll()
        }
        
        do {
            for item in selectedAccounts {
                try await AccountManager(viewContext).delete(item)
            }
            
            return ResponseToast(.responseAccountsDeleted(selectedAccounts.count), .ok)
        } catch {
            Logger.exception(error)
            return ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    /**
     Deletes the sort selection object in UserDefaults.
     */
    func resetSelectedSort() {
        UserDefaultsManager.removeValue(for: .sortAccounts)
        sortSelection = UserDefaultsManager.sortAccounts
    }
}
