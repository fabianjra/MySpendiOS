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
        for item in 0..<5 {
            
            let newItem = Category(context: viewContext)
            newItem.dateCreated = Calendar.current.date(byAdding: .day, value: item, to: .now)!
            newItem.dateModified = .now
            newItem.id = UUID()
            newItem.isActive = true
            
            newItem.dateLastUsed = .now
            newItem.icon = "✅"
            newItem.name = "Prueba_Check number: \(item)"
            newItem.type = CategoryType.expense.rawValue
            newItem.usageCount = 1
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al cargar CoreData en MockCategory: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
