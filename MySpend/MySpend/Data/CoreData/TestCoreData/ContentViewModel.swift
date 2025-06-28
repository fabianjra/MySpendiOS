//
//  ContentViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/6/25.
//

import Foundation
import CoreData
import Combine

class ContentViewModel: ObservableObject {
    
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
            categories = try CategoryManager(viewContext: viewContext).fetchAllCategories()
        } catch {
            Logs.CatchException(error, type: .CoreData)
            //categories = [] //TODO: Validar si es necesario en caso de que ya se hayan cargado categories.
        }
    }
    
    func addNewCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).CraateNewCategory(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func deleteCategory(_ item: CategoryModel) {
        do {
            try CategoryManager(viewContext: viewContext).deleteCategory(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func deleteCategory(at indexSet: IndexSet, from categories: [CategoryModel]) {
        do {
            try CategoryManager(viewContext: viewContext).deleteCategory(at: indexSet, from: categories)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
