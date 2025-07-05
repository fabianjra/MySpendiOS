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
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    
    // MARK: READ

    func fetchAll(predicateFormat: String = CDConstants.Predicates.isActive,
                              predicateArgs: [Any] = [true],
                  sortedBy sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Account.dateCreated, ascending: true)])
    throws -> [AccountModel] {
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        
        let coreDataEntities = try viewContext.fetch(request)
        
        let models = coreDataEntities.map { entity in
            AccountModel(entity)
        }
        
        return models
    }
}
