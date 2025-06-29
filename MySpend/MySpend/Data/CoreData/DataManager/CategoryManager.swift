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
    
    func fetchAllCategories(predicateFormat: String = CDConstants.Predicates.isActive,
                            predicateArgs: [Any] = [true],
                            sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) throws -> [CategoryModel] {
        /* Example:
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
    
    func updateCategory(_ model: CategoryModel) throws {
        let item = try fetchedCategory(model)
        
        item.icon = model.icon
        item.name = model.name
        item.type = model.type.rawValue
        item.isActive = model.isActive
        item.dateModified = .now
        
        try viewContext.save()
    }
    
    
    // MARK: DELETE
    
    func deleteCategory(_ model: CategoryModel) throws {
        let item = try fetchedCategory(model)
        
        viewContext.delete(item)
        try viewContext.save()
    }
    
    func deleteCategory(at offsets: IndexSet, from items: [CategoryModel]) throws {
        for offset in offsets {
            let model = items[offset]
            try deleteCategory(model)
        }
    }
    
    
    // MARK: SHARED
    
    private func createFetchRequest(_ model: CategoryModel) -> NSFetchRequest<Category> {
        
        // Primero se necesita hacer el Fetch Request para saber cual nota se va a modificar.
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // NSPredicate permite buscar un valore de una entidad filtrando.
        // NSPredicate solamente establece una configuracion de busqueda. Aun no se busca nada aqui.
        // Format: formato de filtro (en este caso, busqueda por ID).
        // argument: Reemplazo del %@ para igualarlo al valor a buscar.
        fetchRequest.predicate = NSPredicate(format: CDConstants.Predicates.findItemById, model.id.uuidString)
        fetchRequest.fetchLimit = 1 //Solamente obtiene 1 resultado.
        
        return fetchRequest
    }
    
    private func fetchedCategory(_ model: CategoryModel) throws -> Category {
        let fetchRequest = createFetchRequest(model)
        let itemCoreData = try viewContext.fetch(fetchRequest)
        
        guard let item = itemCoreData.first else {
            throw CDError.notFound(id: model.id, entity: Category.description())
        }
        
        return item
    }
}
