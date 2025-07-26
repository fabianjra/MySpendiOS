//
//  CoreDataUtilities.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 4/7/25.
//

import CoreData

struct CoreDataUtilities {
    
    static var shared: CoreDataUtilities = CoreDataUtilities()
    var mockDataType = MockDataType.normal
    
    @MainActor
    static var getViewContext: NSManagedObjectContext {
        if UtilsUI.isRunningOnCanvasPreview {
            switch CoreDataUtilities.shared.mockDataType {
            case .empty:
                return MockCoreDataEmpty.preview.container.viewContext
                
            case .normal:
                return MockCoreDataNormal.preview.container.viewContext

            case .saturated:
                return MockCoreDataSaturated.preview.container.viewContext
            }
        } else {
            return PersistenceController.shared.container.viewContext
        }
    }

    /**
     Fetches the `Entity` entity whose primary key matches `id`.
     Should be called only inside the closures: `context.perform { }` or `performAndWait { }`
     
     Internally the method:
     1. Creates an `NSFetchRequest<T>` using `String(describing: entity)` to derive the entity name.
     2. Adds the predicate defined in `CDConstants.Predicates.byID` with `id` as its argument (`id == %@`).
     3. Sets `fetchLimit` to `1`, ensuring a single-row result.
     
     - Parameters:
        - byID: the ID (UUID.uuidString) for the entity to find.
        - entity: `Entity` to look for. Eg: Account.self, Category.self or Transaction.self
        - viewContextArg: The managed-object context that executes the fetch.
     
     - Returns: The matching `Entity` entity, or `nil` if none exists.
     - Throws: Any error thrown by `viewContextArg.fetch(_:)`.
     - Date: Jul 2025
     */
    static func fetch<T: NSManagedObject>(ByID id: String, entity: T.Type, viewContextArg: NSManagedObjectContext) throws -> T? {
        let request = NSFetchRequest<T>(entityName: entity.entityName)
        request.predicate  = NSPredicate(format: CDConstants.Predicate.byID, id)
        request.fetchLimit = 1
        
        let entity = try viewContextArg.fetch(request)
        return entity.first
    }
    
    
    // MARK: CATEGORY
    
    static func createCategoryEntity(from model: CategoryModel, viewContext: NSManagedObjectContext) -> Category {
        let entity = Category(context: viewContext)
        entity.dateCreated   = model.dateCreated
        entity.dateModified  = model.dateModified
        entity.id            = model.id
        entity.isActive      = model.isActive
        
        entity.dateLastUsed  = model.dateLastUsed
        entity.icon          = model.icon
        entity.name          = model.name
        entity.type          = model.type.rawValue
        entity.usageCount    = Int64(model.usageCount)
        
        viewContext.processPendingChanges()
        return entity
    }
    
    
    // MARK: ACCOUNT
    
    static func createAccountEntity(from model: AccountModel, viewContext: NSManagedObjectContext) -> Account {
        let entity = Account(context: viewContext)
        entity.dateCreated   = model.dateCreated
        entity.dateModified  = model.dateModified
        entity.id            = model.id
        entity.isActive      = model.isActive
        
        entity.icon          = model.icon
        entity.name          = model.name
        entity.notes         = model.notes
        entity.type          = model.type.rawValue
        entity.userId        = model.userId
        
        viewContext.processPendingChanges()
        return entity
    }
}
