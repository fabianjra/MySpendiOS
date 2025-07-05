//
//  CoreDataUtilities.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 4/7/25.
//

import CoreData

struct CoreDataUtilities {
    
    /**
     Builds a typed `NSFetchRequest` that retrieves **at most one** Core Data object whose `id` matches the supplied string.
     
     Internally the method:
     1. Creates an `NSFetchRequest<T>` using `String(describing: entity)` to derive the entity name.
     2. Adds the predicate defined in `CDConstants.Predicates.findItemById` with `id` as its argument (`id == %@`).
     3. Sets `fetchLimit` to `1`, ensuring a single-row result.
     
     Example:
     ```swift
     let request = CoreDataUtils.createFetchRequest(ByID: uuidString,
                                                    entity: Transaction.self)
     let transaction = try context.fetch(request).first
     ```
     
     - Parameters:
       - id: The UUID string to match against the entity’s `id` attribute.
       - entity: The Core Data class to be fetched (e.g., `Category.self`).
     
     - Returns: A fully-configured `NSFetchRequest<T>` ready for execution.
     */
    static func createFetchRequest<T: NSManagedObject>(ByID id: String, entity: T.Type) -> NSFetchRequest<T> {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate  = NSPredicate(format: CDConstants.Predicates.findItemById, id)
        request.fetchLimit = 1
        return request
    }
}
