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
    case newPasswordIsDifferent
}

extension ErrorMessages: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptySpace: return NSLocalizedString("Fill the empty space.", comment: "")
        case .emptySpaces: return NSLocalizedString("Fill the empty spaces.", comment: "")
        case .newPasswordIsDifferent: return NSLocalizedString("New password and confirm password are different.", comment: "")
        }
    }
}
