//
//  Messages.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/23.
//

import Foundation

public enum Errors: Error {
    
    // MARK: UI
    case successful
    case empty
    case generic
    case emptySpace
    case emptySpaces
    case creationPasswordIsDifferent
    case newPasswordIsDifferent
    case passwordIsShort
    case invalidAmount
    
    // MARK: CORE DATA UI
    case notFoundAccount
    case accountTypeNotMatchCategoryType(String, String)
    case cannotUpdateAccountWithTransactions(String)
    case cannotUpdateCategoryDueToAccountType(String)
    
    // MARK: CORE DATE MAGER
    case notSavedAccount(String)
    case notSavedTransaction(String)
    case notSavedCategory(String)
        
    // MARK: FIREBASE
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
            
            // MARK: UI
        case .successful: return NSLocalizedString("Successful", comment: "")
        case .empty: return NSLocalizedString("", comment: "")
        case .generic: return NSLocalizedString("Something wrong happened, try again.", comment: "")
        case .emptySpace: return NSLocalizedString("Fill the empty space.", comment: "")
        case .emptySpaces: return NSLocalizedString("Fill the empty spaces.", comment: "")
        case .creationPasswordIsDifferent: return NSLocalizedString("The password and confirm password are different.", comment: "")
        case .newPasswordIsDifferent: return NSLocalizedString("New password and confirm password are different.", comment: "")
        case .passwordIsShort: return NSLocalizedString("The password should be larger than \(ConstantViews.passwordMinimumLength) characters.", 
                                                        comment: "")
        case .invalidAmount: return NSLocalizedString("Amount is invalid.", comment: "")
            
            // MARK: CORE DATA UI
        case .notFoundAccount: return NSLocalizedString( "Accounts not found. Try adding a new one in settings.", comment: "")
        case .accountTypeNotMatchCategoryType(let accountName, let accountType): return NSLocalizedString("The account \"\(accountName)\" accepts only \(accountType) transactions.",
                                                                                         comment: "Shown when the user tries to assign a category whose type doesn’t match the account’s configured type (expense / income).")
        case .cannotUpdateAccountWithTransactions(let count): return NSLocalizedString("Cannot update this account, because it has \(count) transactions associated to an incompatible category type.",
                                                                                       comment: "Shown when the user tries to update an account with transactions associated to it.")
        case .cannotUpdateCategoryDueToAccountType(let count): return NSLocalizedString("Cannot update this category, because it has \(count) transactions associated to an incompatible account type.", comment: "")
            
            // MARK: CORE DATE MAGER
        case .notSavedAccount(let itemId): return NSLocalizedString("Error while saving account for ID: \(itemId)", comment: "")
        case .notSavedTransaction(let itemId): return NSLocalizedString("Error while saving transaction for ID: \(itemId)", comment: "")
        case .notSavedCategory(let itemId): return NSLocalizedString("Error while saving category for ID: \(itemId)", comment: "")

                
            // MARK: FIREBASE
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
            
            // MARK: UI
        case .successful : return 0
        case .empty : return 1
        case .generic: return 2
        case .emptySpace: return 3
        case .emptySpaces: return 4
        case .creationPasswordIsDifferent: return 5
        case .newPasswordIsDifferent: return 6
        case .passwordIsShort: return 7
        case .invalidAmount: return 8
            
            // MARK: CORE DATA UI
        case .notFoundAccount: return 100
        case .accountTypeNotMatchCategoryType: return 101
        case .cannotUpdateAccountWithTransactions: return 102
        case .cannotUpdateCategoryDueToAccountType: return 103
            
            // MARK: CORE DATE MAGER
        case .notSavedAccount: return 200
        case .notSavedTransaction: return 201
        case .notSavedCategory: return 202
            
            // MARK: FIREBASE
        case .userNotLoggedIn: return 300
        case .userNotExists: return 301
        case .userIsValidated: return 302
        case .userCreatedNoName: return 303
        case .userCreatedNoSendEmail: return 304
        case .emailSent: return 305
            
        case .notGetDataFromDocument: return 306
        case .notGetDataFromCollection: return 307
        case .notGetDataFromCollectionChanges: return 308
            
        case .decodeDocument: return 309
        case .addDuplicatedDocument: return 310
        }
    }
}
