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
    
    static func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func getUserName(completionHandler: (String, Error?) -> Void) {
        if let user = getCurrentUser() {
            completionHandler(user.displayName ?? "", nil)
        } else {
            completionHandler("", ConstantMessages.userNotLoggedIn)
        }
    }
    
    // Migrar de ChangeNameView (Se utilizaba solamente en registro y en vista de cambio de nombre).
    static func updateUserName(newUserName: String, user: User? = getCurrentUser(), completionHandler: @escaping (User?, Error?) -> Void) {
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
            completionHandler(nil, ConstantMessages.userNotLoggedIn)
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
                            completionHandler(true, ConstantMessages.empty)
                        }
                    }
                }
            }
        } else {
            completionHandler(false, ConstantMessages.userNotLoggedIn)
        }
    }
    
    static func singIn(_ email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: Error) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completionHandler(false, error)
            } else {
                completionHandler(true, ConstantMessages.empty)
            }
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

// Updated To use Firebase with Async/Await || Version 10.17.0
extension SessionStore {
    
    static func createUser(withEmail email: String, password: String, username: String) async throws {
        
        let user = try await Auth.auth().createUser(withEmail: email, password: password).user
        
        try await updateUser(newUserName: username, user: user)
        
        //Try to create a new user collection to store the user data:
        let userModel = UserModel(id: user.uid, fullname: user.displayName ?? "", email: user.email ?? "", transactions: [])
        try await storeNewUser(user: userModel)
        
        try await sendEmailRegisteredUser()
    }
    
    static func updateUser(newUserName: String, user: User? = getCurrentUser()) async throws {
        if let user = user {
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newUserName
            
            try await changeRequest.commitChanges()
        } else {
            throw ConstantMessages.userNotLoggedIn
        }
    }
    
    static func storeNewUser(user: UserModel) async throws {
        
        let encodedUser = try Firestore.Encoder().encode(user)
        let createRequest = Firestore.firestore().collection("users").document(user.id)
        
        try await createRequest.setData(encodedUser)
    }
    
    static func sendEmailRegisteredUser(user: User? = getCurrentUser()) async throws {
        
        if let user = user {
            try await user.sendEmailVerification()
        } else {
            throw ConstantMessages.userNotLoggedIn
        }
    }
    
//    static func setNewTransaction(transactionModel: TransactionModel) async throws -> ResponseModel {
//        if let userId = getCurrentUser()?.uid {
//            
//            //let encodedNewTransaction = try Firestore.Encoder().encode(transactionModel)
//            
//            let userRef = Firestore.firestore().collection("users").document(userId)
//            
//            // Recuperar el documento del usuario, modificar el arreglo y actualizar Firestore
//            let document = try await userRef.getDocument()
//            
//            if document.exists {
//                
//                var user = try document.data(as: UserModel.self)
//                
//                if var transactionCollection = user.transactions {
//                    transactionCollection.append(transactionModel)
//                } else {
//                    //TODO: ¿Como se agrega la coleccion si no existe en Firebase Firestore?
//                }
//                
//                try userRef.setData(from: user)
//                return ResponseModel()
//            } else {
//                return ResponseModel(ConstantCodeResponse.ok, ConstantMessages.userNotExists.localizedDescription)
//            }
//        } else {
//            return ResponseModel(ConstantCodeResponse.genericError, ConstantMessages.userNotLoggedIn.localizedDescription)
//        }
//    }
    
    static func setNewTransaction(transactionModel: TransactionModel) async throws -> ResponseModel {
        
        guard let userId = getCurrentUser()?.uid else {
            return ResponseModel(ConstantCodeResponse.error, ConstantMessages.userNotLoggedIn.localizedDescription)
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        do {
            let response = try await db.runTransaction { (transaction, errorPointer) -> Any? in
                
                let userDocument: DocumentSnapshot
                
                do {
                    try userDocument = transaction.getDocument(userRef)
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
                    try transaction.setData(from: user, forDocument: userRef)
                } catch let error {
                    errorPointer?.pointee = error as NSError
                    Logs.WriteCatchExeption(error: error)
                    return ResponseModel(ConstantCodeResponse.error, ConstantMessages.cantSetDataFB.localizedDescription)
                }
                
                return ResponseModel()
            }
            
            return response as! ResponseModel
        } catch {
            Logs.WriteCatchExeption(error: error)
            return ResponseModel(ConstantCodeResponse.error, error.localizedDescription)
        }
    }
    
    //TODO: Agregar al OnAppear de la vista de Resumen para probar su funcionalidad.
    static func getTransactions() async throws -> [TransactionModel] {
        if let userId = getCurrentUser()?.uid {
            
            let collectionTransactions = Firestore.firestore().collection("users").document(userId).collection("transactions")
            
            let decodedTransaction = try Firestore.Decoder().decode(TransactionModel.self, from: collectionTransactions)
            
            let documentsSnapshot = try await collectionTransactions.getDocuments()
            
            var transactions: [TransactionModel] = []
            
            for document in documentsSnapshot.documents {
                if let transaction = try? document.data(as: TransactionModel.self) {
                    transactions.append(transaction)
                }
            }
            
            return transactions
        } else {
            throw ConstantMessages.userNotLoggedIn
        }
    }
}
