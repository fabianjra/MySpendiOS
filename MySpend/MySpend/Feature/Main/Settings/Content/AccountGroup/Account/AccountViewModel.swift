//
//  AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

class AccountViewModel: BaseViewModel {
    
    @Published var models: [AccountModel] = []
    @Published var modelType: AccountType = .general
    
    // MARK: EDIT
    @Published var isEditing: Bool = false
    @Published var selectedModels = Set<AccountModel>()
    
    // MARK: SORT
    @Published var sortModelsBy = UserDefaultsManager.sortAccounts
    
    // MARK: MODALS AND POPUPS
    @Published var showNewItemModal = false
    @Published var showModifyItemModal = false
    
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    
    /// Llamar en `onAppear`
    func activateObservers() {
        startObservingContextChanges { [weak self] in
            self?.fetchAll()
        }
        
        fetchAll() // primera carga
    }
    
    /// Llamar en `onDisappear`
    func deactivateObservers() {
        stopObservingContextChanges()
    }
    
    private func fetchAll() {
        do {
            models = try AccountManager(viewContext: viewContext).fetchAll()
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func delete(_ model: AccountModel) -> ResponseModel {
        do {
            try AccountManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteMltipleItems() -> ResponseModel {
        do {
            for item in selectedModels {
                try AccountManager(viewContext: viewContext).delete(item)
            }
            
            selectedModels.removeAll()
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    /**
     Updates the sort selection to store in UserDefaults.
     */
    func updateSelectedSort() {
        UserDefaultsManager.sortAccounts = sortModelsBy
    }
    
    /**
     Deletes the sort selection object in UserDefaults.
     */
    func resetSelectedSort() {
        UserDefaultsManager.removeValue(for: .sortAccounts)
        sortModelsBy = UserDefaultsManager.sortAccounts
    }
}
