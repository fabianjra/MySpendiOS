//
//  TEST_AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import CoreData
import Combine

@MainActor
class TEST_AccountViewModel: ObservableObject {
    
    @Published var accounts: [AccountModel] = []
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    /// Este es un inicializador secundario (un atajo) que delega la construcción en otro inicializador designado, facilitando distintas formas de crear la misma clase sin repetir código.
    /// No recibe parámetros.
    /// Llama a self.init(viewContext: …) para delegar la construcción.
    /// Usa CoreDataUtilities.getViewContext() para decidir —en tiempo de ejecución— si devuelve el contexto real o el de mock para los previews.
    convenience init() {
        self.init(viewContext: CoreDataUtilities.getViewContext())
    }

    init(viewContext: NSManagedObjectContext) {
            self.viewContext = viewContext
        
        //Subscribirse a cambios en el Context:
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .sink { [weak self] _ in
                self?.fetchAll()
            }
            .store(in: &cancellables)
    }
    
    func fetchAll() {
        do {
            accounts = try AccountManager(viewContext: viewContext).fetchAll()
        } catch {
            Logger.exception(error, type: .CoreData)
            //categories = [] //TODO: Validar si es necesario en caso de que ya se hayan cargado categories.
        }
    }
    
    func addNewItem(_ item: AccountModel) {
        do {
            try AccountManager(viewContext: viewContext).create(item)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func updateItem(_ item: AccountModel) {
        do {
            try AccountManager(viewContext: viewContext).update(item)
        } catch CDError.notFoundFetch {
            
            //TODO: Mejorar implementacion:
            // Se crea este de not found para el tipo de error personalizado a mostrar en pantalla.
            // Por ejemplo, ID no encontrado para ser actualizado
            
            let error = Logger.createError(domain: .accountDatabase, error: Errors.notSavedAccount(item.id.uuidString))
            Logger.exception(error, type: .CoreData)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func delete(_ item: AccountModel) {
        do {
            try AccountManager(viewContext: viewContext).delete(item)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func delete(at indexSet: IndexSet, from items: [AccountModel]) {
        do {
            try AccountManager(viewContext: viewContext).delete(at: indexSet, from: items)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
}
