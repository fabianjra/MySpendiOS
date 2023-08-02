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
    
    static func updateUserName(newUserName: String, user: User?, completionHandler: @escaping (User?, Error?) -> Void) {
        if let user = user {
            
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
    
    static func updatePassword(actualPassword: String, newPasword: String,
                               completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        if let user = getCurrentUser() {
            
            let userEmail = user.email ?? ""
            
            //EMAIL:
            let credential = EmailAuthProvider.credential(withEmail: userEmail, password: actualPassword)
            
            //FACEBOOK:
            //let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.currentAccessToken().tokenString)
            
            //TWITTER:
            //let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
            
            //GOOGLE:
            //let authentication = user.authentication
            //let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            
            // Prompt the user to re-provide their sign-in credentials
            user.reauthenticate(with: credential) { result, error in
                
                if let error = error {
                    completionHandler(false, error)
                } else {
                    user.updatePassword(to: newPasword) { error in
                        
                        if let error = error {
                            completionHandler(false, error)
                            
                        } else {
                            completionHandler(true, ErrorMessages.empty)
                        }
                    }
                }
            }
        } else {
            completionHandler(false, ErrorMessages.userNotLoggedIn)
        }
    }
    
    static func sendEmailValidation(user: User?, completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        if let user = user {
            user.sendEmailVerification { error in
                if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(true, ErrorMessages.generic)
                }
            }
        } else {
            completionHandler(false, ErrorMessages.userNotLoggedIn)
        }
    }
    
    static func registerUser(_ email: String, password: String,
                             completionHandler: @escaping (_ success: Bool, _ user: User?, _ error: Error) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { userData, error in
            if let error = error {
                completionHandler(false, nil, error)
            } else {
                completionHandler(true, userData?.user, ErrorMessages.empty)
            }
        }
    }
    
    static func singIn(_ email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completionHandler(false, error)
            } else {
                completionHandler(true, ErrorMessages.empty)
            }
        }
    }
    
    static func signOut(completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(true, ErrorMessages.generic)
        } catch {
            completionHandler(false, error)
        }
    }
}
