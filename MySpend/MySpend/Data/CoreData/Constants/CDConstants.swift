//
//  CDConstants.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/6/25.
//

struct CDConstants {
    static let containerName: String = "MySpend" // Debe ser el mismo nombre del archivo del modelo.
    
    // MARK: ACCOUNT NAMES
    static let mainAccountName: String = "Main account"
    
    // MARK: PREDICATES
    struct Predicate {
        
        // General:
        static let byID: String = "id == %@"
        static let byIsActive: String = "isActive == %@"
        
        // Account:
        static let byAccountId: String = "account.id == %@"
        static let byAccountType: String = "account.type == %@"
        
        // Category:
        static let byCategoryId: String = "category.id == %@"
        static let byCategoryType: String = "category.type == %@"
    }
}
