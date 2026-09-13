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
    
    //var models: [AccountModel] = []
    
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
    
    var showToast: Bool = false
    var responseToast = ResponseToast() {
        didSet {
            showToast = true
        }
    }
    
    private var viewContextObserver: AnyCancellable?
    private let viewContext: NSManagedObjectContext

    init() {
        self.viewContext = CoreDataUtilities.getViewContext
        
        Task {
            await fetchAccounts()
        }
        
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
    
    private func fetchAccounts() async {
        do {
            allAccounts = try await AccountManager(viewContext)
                .fetchAll()
                .sortedAccounts(by: sortSelection)
            
        } catch {
            Logger.exception(error, type: .CoreData)
            responseToast = ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
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
    
    func delete() async {
        guard let accountToUpdate = accountToDelete else { return }
        
        defer {
            self.accountToDelete = nil
        }
        
        do {
            try await AccountManager(viewContext).delete(accountToUpdate)
            responseToast = ResponseToast(.responseAccountsDeleted(.zero), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            responseToast = ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func deleteMltipleItems() async {
        defer {
            isEditing = false
            selectedAccounts.removeAll()
        }
        
        do {
            for item in selectedAccounts {
                try await AccountManager(viewContext).delete(item)
            }
            
            responseToast = ResponseToast(.responseAccountsDeleted(selectedAccounts.count), .ok)
        } catch {
            Logger.exception(error)
            responseToast = ResponseToast(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
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
