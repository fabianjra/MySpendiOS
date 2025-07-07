//
//  TEST_TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import CoreData
import Combine

class TEST_TransactionViewModel: ObservableObject {
    
    @Published var transactions: [TransactionModel] = []
    
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
            transactions = try TransactionManager(viewContext: viewContext).fetchAll()
        } catch {
            Logs.CatchException(error, type: .CoreData)
            //categories = [] //TODO: Validar si es necesario en caso de que ya se hayan cargado categories.
        }
    }
    
    func addNewItem(_ item: TransactionModel) {
        do {
            try TransactionManager(viewContext: viewContext).create(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func updateItem(_ item: TransactionModel) {
        do {
            try TransactionManager(viewContext: viewContext).update(item)
        } catch CDError.notFound {
            
            //TODO: Mejorar implementacion:
            // Se crea este de not found para el tipo de error personalizado a mostrar en pantalla.
            // Por ejemplo, ID no encontrado para ser actualizado
            
            let error = Logs.createError(domain: .accountDatabase, error: Errors.notSavedTransaction(item.id.uuidString))
            Logs.CatchException(error, type: .CoreData)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func delete(_ item: TransactionModel) {
        do {
            try TransactionManager(viewContext: viewContext).delete(item)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
    
    func delete(at indexSet: IndexSet, from items: [TransactionModel]) {
        do {
            try TransactionManager(viewContext: viewContext).delete(at: indexSet, from: items)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
