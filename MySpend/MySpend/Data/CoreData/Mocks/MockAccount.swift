//
//  MockAccount.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 6/7/25.
//

import Foundation

struct MockAccount {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<5 {
            
            let newItem = Account(context: viewContext)
            newItem.dateCreated = .now
            newItem.dateModified = .now
            newItem.id = UUID()
            newItem.isActive = true
            
            newItem.icon = "💳"
            newItem.name = "General_account"
            newItem.notes = "notes..."
            newItem.type = AccountType.general.rawValue
            newItem.userId = "Firebase_User_UUID"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al cargar CoreData en MockAccount: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
