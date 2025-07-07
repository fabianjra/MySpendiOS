//
//  TEST_CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/25.
//

import Foundation
import CoreData
import Combine

class TEST_CategoryViewModel: ObservableObject {
    
    @Published var categories: [CategoryModel] = []
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
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
            categories = try CategoryManager(viewContext: viewContext).fetchAll(sortedBy: CDSort.CategoryEntity.byName_dateCreated)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            //categories = [] //TODO: Validar si es necesario en caso de que ya se hayan cargado categories.
        }
    }
    
    func addNewCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).create(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func updateCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).update(item)
        } catch CDError.notFound {
            
            //TODO: Mejorar implementacion:
            // Se crea este de not found para el tipo de error personalizado a mostrar en pantalla.
            // Por ejemplo, ID no encontrado para ser actualizado
            
            let error = Logs.createError(domain: .categoriesDatabase, error: Errors.notSavedCategory(""))
            Logs.CatchException(error, type: .CoreData)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func deleteCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).delete(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func deleteCategory(at indexSet: IndexSet, from categories: [CategoryModel]) {
        do {
            try CategoryManager(viewContext: viewContext).delete(at: indexSet, from: categories)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
