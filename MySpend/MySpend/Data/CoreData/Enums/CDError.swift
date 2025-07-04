//
//  CDError.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/6/25.
//

import Foundation

enum CDError: Error {
    case notFound(id: UUID, entity: String)
    case duplicateEntity(name: String, entity: String)
    case invalidData(String)
}

extension CDError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFound(let id, let entity): return NSLocalizedString("No entity of type \"\(entity)\" was found with id: \(id).", comment: "")
        case .duplicateEntity(let name, let entity): return NSLocalizedString("An entity of type \"\(entity)\" with the name \"\(name)\" already exists.", comment: "")
        case .invalidData(let reason): return NSLocalizedString("Invalid data: \(reason)", comment: "")
        }
    }
}
