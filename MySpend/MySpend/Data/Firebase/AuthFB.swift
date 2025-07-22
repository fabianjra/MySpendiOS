//
//  SessionStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import FirebaseAuth
//import FirebaseFirestoreSwift

// Updated To use Firebase with Async/Await || Version 10.17.0
public struct AuthFB: UserValidationProtocol {
    
    public var currentUser: User? = Auth.auth().currentUser
    
    func singIn(_ email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func singOut() throws {
        try Auth.auth().signOut()
    }
    
    //TODO: Agregar funcion de Transaccion para que sea atomico (Se complete todo o no haga ninguna accion).
    func updatePassword(actualPassword: String, newPasword: String) async throws {
        let user = try validateCurrentUser(currentUser)
        
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
        try await user.reauthenticate(with: credential)
        
        try await user.updatePassword(to: newPasword)
    }
    
    //TODO: Agregar funcion de Transaccion para que sea atomico (Se complete todo o no haga ninguna accion).
    func registerUser(withEmail email: String, password: String, username: String) async throws {
        
        let user = try await Auth.auth().createUser(withEmail: email, password: password).user
        
        try await updateUser(newUserName: username, forUser: user)
        
        //let userModel = UserModelFB(id: user.uid, fullname: user.displayName ?? "", email: user.email ?? "")
        
        //try await UserDatabase().storeUserDocument(forUser: userModel)
    }

    func updateUser(newUserName: String, forUser user: User) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newUserName
        
        try await changeRequest.commitChanges()
    }
    
    func updateUser(newUserName: String) async throws {
        let user = try validateCurrentUser(currentUser)
        
        try await updateUser(newUserName: newUserName, forUser: user)
    }

    func sendEmailRegisteredUser() async throws {
        let user = try validateCurrentUser(currentUser)
        
        try await user.sendEmailVerification()
    }
}
