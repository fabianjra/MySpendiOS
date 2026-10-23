//
//  CategoryManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/10/26.
//

import CoreData
import Combine

@MainActor
@Observable
final class CategoryManager {
    static let shared = CategoryManager()
    
    private let coreDataManager: CategoryCoreDataManager
    private var allCategories: [CategoryModel] = []
    
    
    // MARK: OBSERVABLES
    
    private var viewContextObserver: AnyCancellable?
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.coreDataManager = CategoryCoreDataManager(viewContext)
        
        Task {
            await refreshCategories()
        }
            
        startObserveViewContextChanges()
    }
    
    /**
     Creates an CategoryManager using the application's default Core Data context.
     
     This convenience initializer delegates to the designated initializer,
     automatically providing the context returned by `CoreDataUtilities.getViewContext`.
     
     Used internally to initialize the shared instance without requiring an explicit context.
     */
    private convenience init() {
        self.init(viewContext: CoreDataUtilities.getViewContext)
    }
    
    private func refreshCategories() async {
        do {
            allCategories = try await coreDataManager.fetchAll()
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    private func startObserveViewContextChanges() {
        guard viewContextObserver == nil else { return } // Evita suscribirse dos veces
        
        viewContextObserver = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main) // Evita multiples llamados
            .sink { [weak self] _ in
                
                Task { @MainActor in
                    await self?.refreshCategories()
                }
            }
    }
    
    
    // MARK: ORDENAMIENTO
    
    var sortedAccounts: [CategoryModel] {
        allCategories.sortedCategories(by: sortSelection)
    }
    
    var sortSelection = UserDefaultsManager.sortCategories {
        didSet { UserDefaultsManager.sortCategories = sortSelection }
    }
    
    func resetSort() {
        sortSelection = CategorySortConfiguration()
    }
}


// MARK: CRUD

extension CategoryManager {
    
    func create(_ category: CategoryModel) async -> ToastResponse {
        if category.name.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
        do {
            try await coreDataManager.create(category)
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func update(_ category: CategoryModel) async -> ToastResponse {
        if category.name.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
        do {
            try await coreDataManager.update(category)
            
            return ToastResponse(.responseSuccesful, .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func delete(_ category: CategoryModel) async -> ToastResponse {
        do {
            try await coreDataManager.delete(category)
            
            return ToastResponse(.responseCategoriesDeleted(.zero), .ok)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
    
    func delete(_ selectedCategories: Set<CategoryModel>) async -> ToastResponse {
        do {
            for item in selectedCategories {
                try await coreDataManager.delete(item)
            }
            
            return ToastResponse(.responseCategoriesDeleted(selectedCategories.count), .ok)
        } catch {
            Logger.exception(error)
            return ToastResponse(LocalizedStringResource(stringLiteral: error.localizedDescription), .error)
        }
    }
}
