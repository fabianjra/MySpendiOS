//
//  CDError.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/6/25.
//

import Foundation

enum CDError: Error {
    case notFoundUpdate(entity: String)
    case unexpectedResultType(expected: String, actual: String)
}

extension CDError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFoundUpdate(let entity): return NSLocalizedString("When Update: Not fount entity of type \"\(entity)\"", comment: "")
        case .unexpectedResultType(let expected, let actual): return NSLocalizedString("Core data failed to convert value type while casting. Value expected: \(expected). Actual value received: \(actual).", comment: "")
        }
    }
}
