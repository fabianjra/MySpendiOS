//
//  CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Combine

class CategoryViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel] = []
    //@Published var categoryType: CategoryType = .expense
    
    // MARK: EDIT
    @Published var isEditing: Bool = false
    @Published var selectedCategories = Set<CategoryModel>()
    
    // MARK: SORT
    @Published var sortCategoriesBy = UserDefaultsManager.sorCategories
    
    // MARK: POPUPS
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    
    /// Llamar en `onAppear`
    func activateObservers() {
        startObserveViewContextChanges { [weak self] in
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
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func delete(_ model: CategoryModel?) -> ResponseModel {
        guard let model = model else { return ResponseModel(.successful) }
        
        do {
            try CategoryManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func deleteMltiple() -> ResponseModel {
        defer {
            isEditing = false
        }
        
        do {
            for item in selectedCategories {
                try CategoryManager(viewContext: viewContext).delete(item)
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
