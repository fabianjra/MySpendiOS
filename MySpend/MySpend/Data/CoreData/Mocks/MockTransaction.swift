//
//  MockTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import Foundation

struct MockTransaction {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for _ in 0..<5 {
            let newItem = Transaction(context: viewContext)
            newItem.dateCreated = .now
            newItem.dateModified = .now
            newItem.id = UUID()
            newItem.isActive = true
            
            newItem.amount = 2000.54
            newItem.dateTransaction = .now
            newItem.notes = "notes_transaction..."
            newItem.category =  CoreDataUtilities.createCategoryEntity(from: CategoryModel(), viewContext: viewContext)
            newItem.account = CoreDataUtilities.createAccountEntity(from: AccountModel(), viewContext: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al cargar CoreData en MockTransaction: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
