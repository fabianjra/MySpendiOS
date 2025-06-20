//
//  PRUEBAS_SessionStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI
import FirebaseAuth
import Firebase
import Combine

struct PRUEBAS_User {
    var uid: String
    var email: String?
    var displayName: String?
}

class PRUEBAS_SessionStore : ObservableObject {
    
    var didChange = PassthroughSubject<PRUEBAS_SessionStore, Never>()
    @Published var session: PRUEBAS_User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user {
                // if we have a user, create a new user model
                self.session = PRUEBAS_User(uid: user.uid, email: user.email, displayName: user.displayName)
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
//    func signUp(email: String, password: String, completionHandler: @escaping AuthDataResultCallback) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: completionHandler)
//    }
//
//    func signIn(email: String, password: String, completionHandler: @escaping AuthDataResultCallback) {
//        Auth.auth().signIn(withEmail: email, password: password, completion: completionHandler)
//    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}


class PRUEBAS_AuthenticationService: ObservableObject {
    
    @Published var user: PRUEBAS_User?
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        registerStateListener()
    }
    
    func signIn() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func updateDisplayName(displayName: String, completionHandler: @escaping (Result<PRUEBAS_User, Error>) -> Void) {
        
        if let user = Auth.auth().currentUser {
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            
            changeRequest.commitChanges { error in
                
                if let error = error {
                    completionHandler(.failure(error))
                    
                } else {
                    if let updatedUser = Auth.auth().currentUser {
                        print("Successfully updated display name for user [\(user.uid)] to [\(updatedUser.displayName ?? "(empty)")]")
                        // force update the local user to trigger the publisher
                        //self.user = updatedUser
                        //completionHandler(.success(updatedUser))
                    }
                }
            }
        }
    }
    
    private func registerStateListener() {
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            print("Sign in state has changed.")
            //self.user = user
            
            if let user = user {
                
                let anonymous = user.isAnonymous ? "anonymously " : ""
                print("User signed in \(anonymous)with user ID \(user.uid). Email: \(user.email ?? "(empty)"), display name: [\(user.displayName ?? "(empty)")]")
                
            } else {
                
                print("User signed out.")
                self.signIn()
            }
        }
    }
    
}
