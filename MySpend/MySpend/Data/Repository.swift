//
//  Repository.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/24.
//

import Firebase

struct Repository: UserValidationProtocol {
    
    var currentUser: User? = AuthFB().currentUser
    
    /**
     This function adds a new document to a Firestore subcollection based on the given model.
     It uses Firebase to generate a new document ID automatically.
     The operation is asynchronous and throws errors if something goes wrong during the process.
     
     **Example:**
     ```swift
     private var listener: ListenerRegistration?
     
     func startListeningForCategoryChanges() {
        do {
            listener = try DatabaseStore.listenUserChanges { [weak self] userLoaded in
            self?.categories = userLoaded
            }
        } catch {
            errorMessage = error.localizedDescription
        }
     }
     
     deinit {
        listener?.remove()
     }
     ```
     
     - Parameters:
        - model: A generic parameter T conforming to Codable. This is the model object that will be encoded and stored as a document in Firestore.
        - collection: A value of the enum type CollectionsFB that specifies the Firestore subcollection where the new document will be added.
     
     - Returns: ListenerRegistration opcional (propiedad de Firebase)
     
     - Throws: Manejo de escepciones por medio de banderas.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Aug 2024
     */
    func addNewDocument<T: Codable>(_ model: T, forSubCollection collection: CollectionsFB) async throws {
        
        let currentUserId = try validateCurrentUser(currentUser).uid
        
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        
        let newDocumentEncoded = try UtilsFB.encodeModelFB(model)
        
        //En este caso Firebase genera un ID automaticamente para el nuevo documento con addDocument.
        try await subCollectionRef.addDocument(data: newDocumentEncoded)
    }
}
