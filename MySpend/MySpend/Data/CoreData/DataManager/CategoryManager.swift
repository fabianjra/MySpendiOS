//
//  CategoryManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/6/25.
//

import CoreData
import SwiftUI

/**
 `CategoryManager` is responsible for managing Core Data storage and handling all data-related operations throughout the app.
 It serves as a bridge between Core Data and the user interface.

 - Authors: Fabian Rodriguez
 - Version: 1.0
 */
struct CategoryManager {
    
    // El ViewContext es lo que se va a modificar.
    // Cuando se agreguen nuevos datos a Core Data, se debe obtener el ViewContext para hacerlo.
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    
    // MARK: READ
    
    func fetchAllCategories(predicateFormat: String = CoreDataConstants.Predicates.isActive,
                            predicateArgs: [Any] = [true],
                            sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) throws -> [CategoryModel] {
        /* // EJEMPLO DE ORDNAR POR VARIOS CAMPOS:
        let sortByNameThenDate = [
            NSSortDescriptor(keyPath: \Category.name, ascending: true),
            NSSortDescriptor(keyPath: \Category.dateCreated, ascending: false) // o true
        ] */
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        
        let coreDataEntities = try viewContext.fetch(request)
        
        let models = coreDataEntities.map { entity in
            CategoryModel(entity)
        }
        
        return models
    }

    
    // MARK: CREATE / UPDATE
    
    func CraateNewCategory(_ category: CategoryModel) throws {
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
        
        try viewContext.save()
    }
    
    func updateCategory(_ category: CategoryModel) throws {
        
        // Primero se necesita hacer el Fetch Request para saber cual nota se va a modificar.
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // NSPredicate permite buscar un valore de una entidad filtrando.
        // NSPredicate solamente establece una configuracion de busqueda. Aun no se busca nada aqui.
        // Format: formato de filtro (en este caso, busqueda por ID).
        // argument: Reemplazo del %@ para igualarlo al valor a buscar.
        fetchRequest.predicate = NSPredicate(format: CoreDataConstants.Predicates.findItemById, category.id.uuidString)
        fetchRequest.fetchLimit = 1 //Solamente obtiene 1 resultado.
        
        // Se realiza la busqueda en base a la configuracion establecida con fetchRequest
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            Logs.WriteMessage("No se pudo actualiza la categoría porquem no se encontró ninguna entidad con id \(category.id.uuidString)")
            return //TODO: Hacer return de item vacio
        }
        
        item.icon = category.icon
        item.name = category.name
        item.type = category.type.rawValue
        item.isActive = category.isActive
        item.dateModified = .now
        
        try viewContext.save()
    }
    
    
    // MARK: DELETE
    
    func deleteCategory(_ model: CategoryModel) throws {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataConstants.Predicates.findItemById, model.id.uuidString)
        fetchRequest.fetchLimit = 1
        
        if let item = try viewContext.fetch(fetchRequest).first {
            
            viewContext.delete(item)
            try viewContext.save()
        } else {
            Logs.WriteMessage("No se pudo eliminar la categoría con id \(model.id.uuidString)")
        }
    }
    
    func deleteCategory(at offsets: IndexSet, from items: [CategoryModel]) throws {
        for offset in offsets {
            let model = items[offset]
            try deleteCategory(model)
        }
    }
    
    func deleteCategory(withId id: UUID) throws {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataConstants.Predicates.findItemById, id.uuidString)
        fetchRequest.fetchLimit = 1

        if let item = try viewContext.fetch(fetchRequest).first {
            viewContext.delete(item)
            try viewContext.save()
        } else {
            Logs.WriteMessage("No se pudo eliminar la categoría con id \(id)") //TODO: Retornar mensaje de error.
        }
    }
}
