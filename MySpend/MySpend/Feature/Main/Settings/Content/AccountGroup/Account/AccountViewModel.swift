//
//  AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Combine
import Foundation

class AccountViewModel: BaseViewModel {
    
    @Published var models: [AccountModel] = []
    
    // MARK: EDIT
    @Published var isEditing: Bool = false
    @Published var selectedModels = Set<AccountModel>()
    
    // MARK: SORT
    @Published var sortModelsBy = UserDefaultsManager.sortAccounts
    
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    
    // MARK: DATA ON SCREEN
    var defaultModelSelected: AccountModel? {
        let defaultID = UserDefaultsManager.defaultAccountID
        guard defaultID.isEmptyOrWhitespace == false else { return nil }
        return models.first { $0.id.uuidString == defaultID }
    }
    
    /// Llamar en `onAppear`
    func activateObservers() async {
        // CoreData:
        startObserveViewContextChanges { [weak self] in
            await self?.fetchAll()
        }
        
        // UserDefaults:
        startObserveUserDefaultsChanges { [weak self] in
            // Se actualiza el objeto que se pasa por parametro,
            // en este caso, es por defecto el userDefaults que ya se envia por defecto en esta funcion en BaseViewModel.
            self?.objectWillChange.send()
        }
        
        // Primera carga:
        await fetchAll()
    }
    
    /// Llamar en `onDisappear`
    func deactivateObservers() {
        stopObservingContextChanges()
        stopObserveUserDefaultsChanges()
    }
    
    private func fetchAll() async {
        do {
            models = try await AccountManager(viewContext).fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            Logger.exception(error, type: .CoreData)
        }
    }

    func delete(_ model: AccountModel?) async -> ResponseModel {
        guard let model = model else { return ResponseModel(.successful) }
        
        do {
            try await AccountManager(viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteMltipleItems() async -> ResponseModel {
        defer {
            isEditing = false
        }
        
        do {
            for item in selectedModels {
                try await AccountManager(viewContext).delete(item)
            }
            
            selectedModels.removeAll()
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error)
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
