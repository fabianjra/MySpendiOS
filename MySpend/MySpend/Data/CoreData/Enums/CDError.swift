//
//  CDError.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/6/25.
//

import Foundation

enum CDError: Error {
    case notFoundFetch(entity: String)
    case notFoundUpdate(entity: String)
    case notFoundDelete(entity: String)
    
    case duplicateEntity(name: String, entity: String)
    case invalidData(String)
}

extension CDError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFoundFetch(let entity): return NSLocalizedString("Fetch: Not fount entity of type \"\(entity)\"", comment: "")
        case .notFoundUpdate(let entity): return NSLocalizedString("Update: Not fount entity of type \"\(entity)\"", comment: "")
        case .notFoundDelete(let entity): return NSLocalizedString("Delete: Not fount entity of type \"\(entity)\"", comment: "")
            
        case .duplicateEntity(let name, let entity): return NSLocalizedString("An entity of type \"\(entity)\" with the name \"\(name)\" already exists.", comment: "")
        case .invalidData(let reason): return NSLocalizedString("Invalid data: \(reason)", comment: "")
        }
    }
}
