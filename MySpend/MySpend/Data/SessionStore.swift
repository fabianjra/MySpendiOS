//
//  SessionStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

//import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class SessionStore {
    
    static func getUserName(completionHandler: (String, Error?) -> Void) {
        if let user = currentUser {
            completionHandler(user.displayName ?? "", nil)
        } else {
            completionHandler("", ConstantMessages.userNotLoggedIn)
        }
    }

    static func updatePassword(actualPassword: String, newPasword: String,
                               completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        if let user = currentUser {
            
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
                            completionHandler(true, ConstantMessages.empty)
                        }
                    }
                }
            }
        } else {
            completionHandler(false, ConstantMessages.userNotLoggedIn)
        }
    }
    
    static func signOut(completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(true, ConstantMessages.empty)
        } catch {
            completionHandler(false, error)
        }
    }
}

private let currentUser = UtilsFB.getCurrentUser()
private let db = Firestore.firestore()
private let userRef = db.collection(ConstantFB.Collections.users)

// Updated To use Firebase with Async/Await || Version 10.17.0
extension SessionStore {
    
    static func singIn(_ email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
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
    
    static func updateUser(newUserName: String, forUser user: User? = currentUser) async throws {
        guard let user = currentUser else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newUserName
        
        try await changeRequest.commitChanges()
    }
    
    private static func storeUserDocument(forUser user: UserModel) async throws {
        
        let encodedUser = try UtilsFB.encodeModelFB(user)
        let createRequest = userRef.document(user.id)
        
        try await createRequest.setData(encodedUser)
    }
    
    static func sendEmailRegisteredUser() async throws {
        guard let user = currentUser else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        try await user.sendEmailVerification()
    }
    
    static func addNewTransaction(transactionModel: TransactionModel) async throws -> ResponseModel {
        
        guard let userId = currentUser?.uid else {
            return ResponseModel(ConstantCodeResponse.error, ConstantMessages.userNotLoggedIn.localizedDescription)
        }
        
        let userRefDocument = userRef.document(userId)
        
        do {
            let response = try await db.runTransaction { (transaction, errorPointer) -> Any? in
                
                let userDocument: DocumentSnapshot
                
                do {
                    try userDocument = transaction.getDocument(userRefDocument)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    Logs.WriteCatchExeption(error: error)
                    return ResponseModel(ConstantCodeResponse.error, ConstantMessages.cantGetDocumentFB.localizedDescription)
                }
                
                guard var user = try? userDocument.data(as: UserModel.self) else {
                    return ResponseModel(ConstantCodeResponse.error, ConstantMessages.generic.localizedDescription)
                }
                
                if user.transactions == nil {
                    user.transactions = []
                }
                
                user.transactions?.append(transactionModel)
                
                do {
                    try transaction.setData(from: user, forDocument: userRefDocument)
                } catch let error {
                    errorPointer?.pointee = error as NSError
                    Logs.WriteCatchExeption(error: error)
                    return ResponseModel(ConstantCodeResponse.error, ConstantMessages.cantSetDataFB.localizedDescription)
                }
                
                //TODO: Cambiar las validaciones de Try Catch, para enviar error con Throw.
                return ResponseModel()
            }
            
            return response as! ResponseModel
        } catch {
            Logs.WriteCatchExeption(error: error)
            return ResponseModel(ConstantCodeResponse.error, error.localizedDescription)
        }
    }
    
    static func getTransactions() async throws -> [TransactionModel] {
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userDocument = userRef.document(userId)
        
        let documentSnapshot = try await userDocument.getDocument()
        
        guard let data = documentSnapshot.data() else {
            return []
        }
        
        let decodedDocument = try UtilsFB.decodeModelFB(data: data, forModel: UserModel.self)
        
        guard let transactions = decodedDocument.transactions else {
            return []
        }
        
        return transactions
    }
}
