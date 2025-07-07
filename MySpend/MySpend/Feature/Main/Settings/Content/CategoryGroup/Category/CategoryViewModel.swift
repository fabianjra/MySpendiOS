//
//  CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Combine

class CategoryViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel] = []
    @Published var categoryType: CategoryType = .expense
    
    // MARK: EDIT
    @Published var isEditing: Bool = false
    @Published var selectedCategories = Set<CategoryModel>()
    
    // MARK: SORT
    @Published var sortCategoriesBy = UserDefaultsManager.sorCategories
    
    // MARK: MODALS AND POPUPS
    @Published var showNewCategoryModal = false
    @Published var showModifyCategoryModal = false
    
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
            categories = try CategoryManager(viewContext: viewContext).fetchAll()
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func deleteCategory(_ model: CategoryModel) -> ResponseModelFB {
        do {
            try CategoryManager(viewContext: viewContext).delete(model)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func deleteMltipleCategories() -> ResponseModelFB {
        do {
            for item in selectedCategories {
                try CategoryManager(viewContext: viewContext).delete(item)
            }
            
            selectedCategories.removeAll()
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModelFB(.error, error.localizedDescription)
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
