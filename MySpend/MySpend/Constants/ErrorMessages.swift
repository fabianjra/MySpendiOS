//
//  ErrorMessages.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import Foundation

enum ErrorMessages: String, Error {
    case emptySpace
    case emptySpaces
}

extension ErrorMessages: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptySpace: return NSLocalizedString("Fill the empty space", comment: "")
        case .emptySpaces: return NSLocalizedString("Fill the empty spaces", comment: "")
        }
    }
}
