//
//  TEST_AccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import CoreData
import Combine

class TEST_AccountViewModel: ObservableObject {
    
    @Published var accounts: [AccountModel] = []
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
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
            Logs.CatchException(error, type: .CoreData)
            //categories = [] //TODO: Validar si es necesario en caso de que ya se hayan cargado categories.
        }
    }
    
    func addNewItem(_ item: AccountModel) {
        do {
            try AccountManager(viewContext: viewContext).create(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func updateItem(_ item: AccountModel) {
        do {
            try AccountManager(viewContext: viewContext).update(item)
        } catch CDError.notFound {
            
            //TODO: Mejorar implementacion:
            // Se crea este de not found para el tipo de error personalizado a mostrar en pantalla.
            // Por ejemplo, ID no encontrado para ser actualizado
            
            let error = Logs.createError(domain: .accountDatabase, error: Errors.notSavedAccount(item.id.uuidString))
            Logs.CatchException(error, type: .CoreData)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func delete(_ item: AccountModel) {
        do {
            try AccountManager(viewContext: viewContext).delete(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func delete(at indexSet: IndexSet, from items: [AccountModel]) {
        do {
            try AccountManager(viewContext: viewContext).delete(at: indexSet, from: items)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
