//
//  CategoryManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/25.
//

import CoreData

/**
 `CategoryManager` is responsible for managing Core Data storage and handling all data-related operations throughout the app.
 It serves as a bridge between Core Data and the user interface.

 - Authors: Fabian Rodriguez
 - Version: 1.0
 */
class CategoryManager {
    
    // El ViewContext es lo que se va a modificar.
    // Cuando se agreguen nuevos datos a Core Data, se debe obtener el ViewContext para hacerlo.
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func saveNewCategory(_ category: CategoryModel) async {
        // Se crea un nuevo objeto "Entity" para mapear los campos que se van a guardar en la Entidad de Note.
        // Se debe utilizar el contexto que ya está instanciado.
        let entity = Category(context: viewContext)
        
        // Shared attributes (Abstract class):
        entity.dateCreated = category.dateCreated
        entity.dateModified = category.dateModified
        entity.id = category.id
        entity.isActive = category.isActive
        
        // Attributes
        entity.dateLastUsed = category.dateLastUsed
        entity.icon = category.icon
        entity.name = category.name
        entity.type = category.type.rawValue
        entity.usageCount = Int64(category.usageCount)
        
        do {
            try viewContext.save()
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
