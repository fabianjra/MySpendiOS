//
//  TEST_CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/25.
//

import CoreData
import Combine

@MainActor
final class TEST_CategoryViewModel: ObservableObject {
    
    @Published var categories: [CategoryModel] = []
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    convenience init() {
        self.init(viewContext: CoreDataUtilities.getViewContext())
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
        //Subscribirse a cambios en el Context:
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .sink { [weak self] _ in
                self?.fectchCategories()
            }
            .store(in: &cancellables)
    }
    
    func fectchCategories() {
        do {
            categories = try CategoryManager(viewContext: viewContext).fetchAll(sortedBy: CDSort.CategoryEntity.byName_DateCreated)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func addNewCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).create(item)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func updateCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).update(item)
        } catch CDError.notFoundFetch {
            
            //TODO: Mejorar implementacion:
            // Se crea este de not found para el tipo de error personalizado a mostrar en pantalla.
            // Por ejemplo, ID no encontrado para ser actualizado
            
            let error = Logger.createError(domain: .categoriesDatabase, error: Errors.notSavedCategory(""))
            Logger.exception(error, type: .CoreData)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func deleteCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).delete(item)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func deleteCategory(at indexSet: IndexSet, from categories: [CategoryModel]) {
        do {
            try CategoryManager(viewContext: viewContext).delete(at: indexSet, from: categories)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
}
