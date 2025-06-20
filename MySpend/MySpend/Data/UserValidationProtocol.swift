//
//  UserValidationProtocol.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 14/10/24.
//

//import Firebase
import FirebaseAuth

protocol UserValidationProtocol {
    func validateCurrentUser(_ currentUser: User?) throws -> User
}

extension UserValidationProtocol {
    func validateCurrentUser(_ currentUser: User?) throws -> User {
        guard let currentUser = currentUser else {
            throw Errors.userNotLoggedIn
        }
        
        return currentUser
    }
}
