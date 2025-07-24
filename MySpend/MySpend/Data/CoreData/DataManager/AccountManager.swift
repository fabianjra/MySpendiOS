//
//  AccountManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 4/7/25.
//

import CoreData

/**
 `AccountManager` is responsible for managing Core Data storage and handling all data-related operations throughout the app.
 It serves as a bridge between Core Data and the user interface.

 - Authors: Fabian Rodriguez
 - Version: 1.0
 */
struct AccountManager {
    private let viewContext: NSManagedObjectContext // Main queue, UI.
    private let bgContext: NSManagedObjectContext // Private queue, background thread.
    
    /**
     Background context for heavy reads / batch ops.
     -----------------------------------------------------------
     • `newBackgroundContext()` → crea un NSManagedObjectContext de tipo `.privateQueueConcurrencyType` asociado al mismo persistent store que `viewContext`.
     • mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
     -----------------------------------------------------
     Cuando este contexto guarda y el store ya tiene cambios procedentes de otro contexto (por ejemplo, viewContext),
     se resuelve el conflicto **propiedad por propiedad**, ganando el valor que este contexto intenta guardar ("lo mío pisa lo del store").
     
     ✓ Útil para contextos que generan o actualizan registros en lote donde asumimos que su información es la más reciente o prioritaria.
     ✱ Si se prefiere lo contrario (mantener lo que esté en disco y descartar lo de este contexto) se usa: `NSMergeByPropertyStoreTrumpMergePolicy`.
     */
    init(viewContext: NSManagedObjectContext, container: NSPersistentContainer = PersistenceController.shared.container) {
        self.viewContext = viewContext
        
        //TODO: Por utilizar, para llamados y saves.
        let background = container.newBackgroundContext()
        background.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.bgContext = background
    }
    
    
    // MARK: READ

    func fetchAll(predicateFormat: String = CDConstants.Predicate.byIsActive,
                  predicateArgs: [Any] = [true],
                  sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Account.dateCreated, ascending: true)])
    async throws -> [AccountModel] {
        
        // Perfom: It's async so dont block de UI
        try await viewContext.perform {
            
            let request: NSFetchRequest<Account> = Account.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
            
            let entities = try viewContext.fetch(request)
            
            let models = entities.map { entity in
                AccountModel(entity)
            }
            
            return models
        }
    }
    
    
    // MARK: CREATE / UPDATE
    
    func create(_ model: AccountModel) async throws {
        try await viewContext.perform {
            
            let entity = Account(context: viewContext)
            
            // Shared attributes (Abstract class):
            entity.dateCreated = .now
            entity.dateModified = .now
            entity.id = model.id
            entity.isActive = model.isActive
            
            // Entity-specific Attributes
            entity.currencyCode = model.currencyCode
            entity.icon = model.icon
            entity.name = model.name
            entity.notes = model.notes
            entity.type = model.type.rawValue
            entity.userId = model.userId
            
            try viewContext.save()
        }
    }
    
    func update(_ model: AccountModel) async throws {
        
        guard let item = try await AccountManager.fetch(model, viewContextArg: viewContext) else {
            throw CDError.notFoundUpdate(entity: Account.description())
        }
        
        try await viewContext.perform {
            // Shared attributes (Abstract class):
            item.dateModified = .now
            item.isActive = model.isActive
            
            // Entity-specific Attributes
            item.currencyCode = model.currencyCode
            item.icon = model.icon
            item.name = model.name
            item.notes = model.notes
            item.type = model.type.rawValue
            item.userId = model.userId
            
            try viewContext.save()
        }
    }

    
    // MARK: DELETE
    
    func delete(_ model: AccountModel) async throws {
        
        guard let item = try await AccountManager.fetch(model, viewContextArg: viewContext) else {
            throw CDError.notFoundDelete(entity: Account.description())
        }
        
        try await viewContext.perform {
            viewContext.delete(item)
            try viewContext.save()
        }
    }
    
    func delete(at offsets: IndexSet, from items: [AccountModel]) async throws {
        for offset in offsets {
            let model = items[offset]
            try await delete(model)
        }
    }
    
    
    // MARK: SHARED
    
    /**
     Fetches the total count of `Account` entities that are stored in CoreData.
     
     - Parameters:
        - viewContextArg: ViewContext used (For preview or default to use in real stored DataBase.
        - predicateFormat: Predicates usted. isActive -> True by default.
        - predicateArgs: Value for the predicates.
     
     - Returns: Int count of all accounts entities stored.
     - Throws: Any error thrown by `viewContextArg.fetch(_:)`.
     - Date: Jul 2025
     */
    func fetchAllCount(predicateFormat: String = CDConstants.Predicate.byIsActive,
                       predicateArgs: [Any] = [true],) async throws -> Int {
        try await viewContext.perform {
            let request: NSFetchRequest<Account> = Account.fetchRequest()
            request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
            request.resultType  = .countResultType
            
            return try viewContext.count(for: request)
        }
    }
    
    /**
     Fetches the `Account` entity whose primary key matches `model.id`.
     
     Internally:
     1. Builds an `NSFetchRequest<Account>` via `CoreDataUtilities.createFetchRequest(ByID:entity:)`, using the model’s UUID string.
     2. Executes the request in `viewContextArg`.
     3. Logs a `.notFound` message and returns `nil` when no matching object is found; otherwise returns the first (and only) result.
     
     - Parameters:
        - model: `AccountModel` whose `id` is used as the lookup key.
        - viewContextArg: The managed-object context that executes the fetch.
     
     - Returns: The matching `Account` entity, or `nil` if none exists.
     - Throws: Any error thrown by `viewContextArg.fetch(_:)`.
     - Date: Jul 2025
     */
    static func fetch(_ model: AccountModel,
                      viewContextArg: NSManagedObjectContext) async throws -> Account? {

        try await viewContextArg.perform {
            let fetchRequest = CoreDataUtilities.createFetchRequest(ByID: model.id.uuidString, entity: Account.self)
            let itemCoreData = try viewContextArg.fetch(fetchRequest)
            
            guard let item = itemCoreData.first else {
                Logger.custom(CDError.notFoundFetch(entity: Account.description()).localizedDescription)
                return nil
            }
            
            return item
        }
    }
    
    /**
     Returns the `Account` Core Data entity matching the given `AccountModel`,
     Creating and inserting a new one when none is found.
     
     Workflow:
     1. Calls `AccountManager.fetch(_:viewContextArg:)` to look up an existing `Account` whose **id** matches `model.id`.
     2. If the entity exists, it is returned as-is.
     3. If no match is found, a brand-new `Account` is created via
     `CoreDataUtilities.createAccountEntity(from:viewContext:)` and returned.
     
     - Parameters:
        - model: The `AccountModel` containing the identifier and field values to search for—or to seed a new entity with.
        - viewContextArg: The `NSManagedObjectContext` in which the lookup/insertion is performed.
     
     - Returns: A managed `Account` object residing in `viewContextArg`.
     - Throws: Rethrows any error raised by `AccountManager.fetch`.
     - Date: Jul 2025
     */
    static func resolve(from model: AccountModel, viewContextArg: NSManagedObjectContext) async throws -> Account {
        if let existing = try await AccountManager.fetch(model, viewContextArg: viewContextArg) {
            return existing
        }
        
        let entity = CoreDataUtilities.createAccountEntity(from: model, viewContext: viewContextArg)
        return entity
    }
}
