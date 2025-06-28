//
//  MockCategory.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/6/25.
//

import Foundation

struct MockCategory {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<5 {
            let newItem = Category(context: viewContext)
            newItem.id = UUID()
            
            newItem.dateCreated = .now
            newItem.dateLastUsed = .now
            newItem.dateModified = .now
            newItem.icon = "star"
            newItem.isActive = true
            newItem.name = "Prueba"
            newItem.type = "expense"
            newItem.usageCount = 0
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
