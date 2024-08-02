//
//  DatabaseStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Firebase
import FirebaseFirestoreSwift

struct DatabaseStore {
    
    static func addNewTransaction(transactionModel: TransactionModel) async throws -> ResponseModel {
        
        guard let userId = UtilsStore.currentUser?.uid else {
            return ResponseModel(ConstantCodeResponse.error, ConstantMessages.userNotLoggedIn.localizedDescription)
        }
        
        let userRefDocument = UtilsStore.userRef.document(userId)
        
        do {
            let response = try await UtilsStore.db.runTransaction { (transaction, errorPointer) -> Any? in
                
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
        guard let userId = UtilsStore.currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userDocument = UtilsStore.userRef.document(userId)
        
        let documentSnapshot = try await userDocument.getDocument()
        
        guard let data = documentSnapshot.data() else {
            return []
        }
        
        let decodedDocument = try UtilsStore.decodeModelFB(data: data, forModel: UserModel.self)
        
        guard let transactions = decodedDocument.transactions else {
            return []
        }
        
        return transactions
    }
}
