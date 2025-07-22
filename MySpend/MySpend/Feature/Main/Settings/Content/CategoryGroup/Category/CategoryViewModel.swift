//
//  CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Combine

class CategoryViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel] = []
    
    // MARK: EDIT
    @Published var isEditing: Bool = false
    @Published var selectedCategories = Set<CategoryModel>()
    
    // MARK: SORT
    @Published var sortCategoriesBy = UserDefaultsManager.sorCategories
    
    // MARK: POPUPS
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    
    /// Llamar en `onAppear`
    func activateObservers() async {
        startObserveViewContextChanges { [weak self] in
            await self?.fetchAll()
        }
        
        await fetchAll() // primera carga
    }
    
    /// Llamar en `onDisappear`
    func deactivateObservers() {
        stopObservingContextChanges()
    }
    
    private func fetchAll() async {
        do {
            categories = try await CategoryManager(viewContext: viewContext).fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func delete(_ model: CategoryModel?) async -> ResponseModel {
        guard let model = model else { return ResponseModel(.successful) }
        
        do {
            try await CategoryManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteMltiple() async -> ResponseModel {
        defer {
            isEditing = false
        }
        
        do {
            for item in selectedCategories {
                try await CategoryManager(viewContext: viewContext).delete(item)
            }
            
            selectedCategories.removeAll()
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
        UserDefaultsManager.sorCategories = sortCategoriesBy
    }
    
    /**
     Deletes the sort selection object in UserDefaults.
     */
    func resetSelectedSort() {
        UserDefaultsManager.removeValue(for: .sortCategories)
        sortCategoriesBy = UserDefaultsManager.sorCategories
    }
}
