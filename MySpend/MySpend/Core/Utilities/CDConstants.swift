//
//  CDConstants.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/6/25.
//

struct CDConstants {
    static let containerName: String = "MySpend" // Debe ser el mismo nombre del archivo del modelo.
    
    // MARK: - PREDICATES
    
    struct Predicate {
        
        // General:
        static let byID: String = "id == %@"
        static let byMultipleID: String = "id IN %@"
    }
}
