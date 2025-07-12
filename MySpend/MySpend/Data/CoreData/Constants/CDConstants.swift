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
    struct Predicates {
        static let findItemById: String = "id == %@"
        static let findItemByAccountId: String = "account.id == %@"
        static let isActive: String = "isActive == %@"
    }
}
