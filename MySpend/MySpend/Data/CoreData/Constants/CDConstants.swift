//
//  CDConstants.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/6/25.
//

import Foundation

struct CDConstants {
    static let containerName: String = "MySpend" // Debe ser el mismo nombre del archivo del modelo.
    
    // MARK: PREDICATES
    struct Predicates {
        static let findItemById: String = "id == %@"
        static let isActive: String = "isActive == %@"
    }
}
