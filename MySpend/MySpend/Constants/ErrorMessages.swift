//
//  ErrorMessages.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import Foundation

enum ErrorMessages: String, Error {
    case empty
    case generic
    case emptySpace
    case emptySpaces
    case newPasswordIsDifferent
    case userNotLoggedIn
    case userIsVerified
    case userCreatedWithoutName
    case userCreatedWithoutSendEmail
}

extension ErrorMessages: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty: return NSLocalizedString("", comment: "")
        case .generic: return NSLocalizedString("Something wrong happened, try again.", comment: "")
        case .emptySpace: return NSLocalizedString("Fill the empty space.", comment: "")
        case .emptySpaces: return NSLocalizedString("Fill the empty spaces.", comment: "")
        case .newPasswordIsDifferent: return NSLocalizedString("New password and confirm password are different.", comment: "")
        case .userNotLoggedIn: return NSLocalizedString("User is not logged in.", comment: "")
        case .userIsVerified: return NSLocalizedString("User is already verified.", comment: "")
        case .userCreatedWithoutName: return NSLocalizedString("The user was created without name, please add your name manually in Settings -> Change my name.", comment: "")
        case .userCreatedWithoutSendEmail: return NSLocalizedString("The user was created without sending the verification email, please send it manually in Settings -> Validate account.", comment: "")
        }
    }
}
