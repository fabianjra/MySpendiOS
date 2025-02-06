//
//  Messages.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import Foundation

public enum Errors: Error {
    case successful
    case empty
    case generic
    case emptySpace
    case emptySpaces
    case creationPasswordIsDifferent
    case newPasswordIsDifferent
    case passwordIsShort
    
    case userNotLoggedIn
    case userNotExists
    case userIsValidated
    case userCreatedNoName
    case userCreatedNoSendEmail
    case emailSent
    
    case notGetDataFromDocument
    case notGetDataFromCollection
    case notGetDataFromCollectionChanges
    
    case decodeDocument(String)
    case addDuplicatedDocument(String)
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .successful: return NSLocalizedString("Successful", comment: "")
        case .empty: return NSLocalizedString("", comment: "")
        case .generic: return NSLocalizedString("Something wrong happened, try again.", comment: "")
        case .emptySpace: return NSLocalizedString("Fill the empty space.", comment: "")
        case .emptySpaces: return NSLocalizedString("Fill the empty spaces.", comment: "")
        case .creationPasswordIsDifferent: return NSLocalizedString("The password and confirm password are different.", comment: "")
        case .newPasswordIsDifferent: return NSLocalizedString("New password and confirm password are different.", comment: "")
        case .passwordIsShort: return NSLocalizedString("The password should be larger than \(ConstantViews.passwordMinimumLength) characters.", 
                                                        comment: "")
        case .userNotLoggedIn: return NSLocalizedString("User is not logged in.", comment: "")
        case .userNotExists: return NSLocalizedString("User is not exists.", comment: "")
        case .userIsValidated: return NSLocalizedString("User is already validated.", comment: "")
        case .userCreatedNoName: return NSLocalizedString("The user was created without name, please add your name manually in Settings -> Change my name.", comment: "")
        case .userCreatedNoSendEmail: return NSLocalizedString("The user was created without sending the verification email, please send it manually in Settings -> Validate account.", comment: "")
        case .emailSent: return NSLocalizedString("Email sent! follow next steps in your email.", comment: "")
            
        case .notGetDataFromDocument: return NSLocalizedString("Could not get data from documentSnapshot", comment: "")
        case .notGetDataFromCollection: return NSLocalizedString("Could not get data from collection snapshot", comment: "")
            
            //TODO: Agregar a que subcoleccion pertenece el documentID.
        case .decodeDocument(let documentId): return NSLocalizedString("Error while trying to decode document form Firebase. ID: \(documentId)", comment: "")
        case .addDuplicatedDocument(let documentId): return NSLocalizedString("Trying to add new document but it's duplicated. ID: \(documentId)", comment: "")
        case .notGetDataFromCollectionChanges: return NSLocalizedString("Could not get the query snapshot", comment: "")
        }
    }
}

extension Errors {
    public var code: Int {
        switch self {
        case .successful : return 0
        case .empty : return 1
        case .generic: return 2
        case .emptySpace: return 3
        case .emptySpaces: return 4
        case .creationPasswordIsDifferent: return 5
        case .newPasswordIsDifferent: return 6
        case .passwordIsShort: return 7
            
        case .userNotLoggedIn: return 8
        case .userNotExists: return 9
        case .userIsValidated: return 10
        case .userCreatedNoName: return 11
        case .userCreatedNoSendEmail: return 12
        case .emailSent: return 13
            
        case .notGetDataFromDocument: return 14
        case .notGetDataFromCollection: return 15
        case .notGetDataFromCollectionChanges: return 16
            
        case .decodeDocument: return 17
        case .addDuplicatedDocument: return 18
        }
    }
}
