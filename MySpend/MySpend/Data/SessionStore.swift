//
//  SessionStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI
import Firebase

class SessionStore {
    
    static func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func getUserName(completionHandler: (String, Error?) -> Void) {
        if let user = getCurrentUser() {
            completionHandler(user.displayName ?? "", nil)
        } else {
            completionHandler("", ErrorMessages.userNotLoggedIn)
        }
    }
    
    static func updateUserName(newUserName: String, completionHandler: @escaping (User?, Error?) -> Void) {
        
        if let user = getCurrentUser() {
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newUserName
            
            changeRequest.commitChanges { error in
                
                if let error = error {
                    completionHandler(nil, error)
                    
                } else {
                    if let updatedUser = Auth.auth().currentUser {
                        completionHandler(updatedUser, nil)
                    }
                }
            }
        } else {
            completionHandler(nil, ErrorMessages.userNotLoggedIn)
        }
    }
    
    static func singIn(_ email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { Result, error in
            if let error = error {
                completionHandler(false, error)
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
    static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
