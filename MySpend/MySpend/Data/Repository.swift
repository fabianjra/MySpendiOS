//
//  Repository.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/24.
//

import Firebase

struct Repository: UserValidationProtocol {
    
    var currentUser: User? = AuthFB().currentUser
    
    func addNewDocument<T: Codable>(_ model: T, forSubCollection collection: CollectionsFB) async throws {
        
        let currentUserId = try validateCurrentUser(currentUser).uid
        
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        
        let newDocumentEncoded = try UtilsFB.encodeModelFB(model)
        
        //En este caso Firebase genera un ID automaticamente para el nuevo documento con addDocument.
        try await subCollectionRef.addDocument(data: newDocumentEncoded)
        
    }
}
