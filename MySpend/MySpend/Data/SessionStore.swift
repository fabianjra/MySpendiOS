//
//  SessionStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import Firebase
import FirebaseFirestoreSwift

// Updated To use Firebase with Async/Await || Version 10.17.0
struct SessionStore {
    
    static func singIn(_ email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    static func singOut() throws {
        try Auth.auth().signOut()
    }
    
    static func getUserName() throws -> String {
        if let user = UtilsStore.currentUser {
            return user.displayName ?? ""
        } else {
            throw ConstantMessages.userNotLoggedIn
        }
    }
    
    //TODO: Agregar funcion de Transaccion para que sea atomico (Se complete todo o no haga ninguna accion).
    static func updatePassword(actualPassword: String, newPasword: String) async throws {
        guard let user = UtilsStore.currentUser else {
            throw ConstantMessages.userNotLoggedIn
        }
        
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
    static func registerUser(withEmail email: String, password: String, username: String) async throws {
        
        let user = try await createUserFB(email, password)
        
        try await updateUser(newUserName: username, forUser: user)
        
        let userModel = UserModel(id: user.uid, fullname: user.displayName ?? "", email: user.email ?? "", transactions: [])
        
        try await storeUserDocument(forUser: userModel)
        
        //try await sendEmailRegisteredUser() //Commented: Will send only via: Validation User View.
    }
    
    private static func createUserFB(_ email: String, _ password: String) async throws -> User{
        return try await Auth.auth().createUser(withEmail: email, password: password).user
    }
    
    static func updateUser(newUserName: String, forUser user: User? = UtilsStore.currentUser) async throws {
        guard let user = UtilsStore.currentUser else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newUserName
        
        try await changeRequest.commitChanges()
    }
    
    private static func storeUserDocument(forUser user: UserModel) async throws {
        
        let encodedUser = try UtilsStore.encodeModelFB(user)
        let createRequest = UtilsStore.userRef.document(user.id)
        
        try await createRequest.setData(encodedUser)
    }
    
    static func sendEmailRegisteredUser() async throws {
        guard let user = UtilsStore.currentUser else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        try await user.sendEmailVerification()
    }
}
