//
//  Repository.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 16/10/24.
//

import Firebase

public struct Repository: UserValidationProtocol {
    
    private var currentUser = AuthFB().currentUser
    
    func getDocument<T: Decodable>(forId documentId: String, forModel model: T.Type, forSubCollection collection: CollectionsFB) async throws -> T? {
        
        let currentUserId = try validateCurrentUser(currentUser).uid
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        
        let documentSnapshot = try await subCollectionRef.document(documentId).getDocument()
        
        guard let documentData = documentSnapshot.data() else {
            return nil
        }
        
        let decodedDocument = try UtilsFB.decodeModelFB(data: documentData, forModel: T.self)
        
        return decodedDocument
    }
    
    /**
     This function adds a new document to a Firestore subcollection based on the given model.
     It uses Firebase to generate a new document ID automatically.
     The operation is asynchronous and throws errors if something goes wrong during the process.
     
     - The function first validates the current user's credentials and retrieves the user's ID.
     - Creates a reference to the specified subcollection for the authenticated user.
     - The given model is encoded into a Firestore-compatible format.
     - Firebase generates a unique document ID automatically when the new document is added to the subcollection using `addDocument`.

     **Changelog:**
     - 1.0: Initial implementation of the function.
     - 1.1: Added return value of `DocumentReference` to allow the access to newly created document's ID.
     
     **Example:**
     ```swift
     @Published var model = CategoryModel()
     
     try await Repository().addNewDocument(model, forSubCollection: .categories)
     ```
     
     - Parameters:
        - model: A generic parameter `T` conforming to `Codable`. This is the model object that will be encoded and stored as a document in Firestore.
        - collection: A value of the enum type `CollectionsFB` that specifies the Firestore subcollection where the new document will be added.
     
     - Returns: The new document added to the Firestore. You can get any value from it, like DocumentID.
     
     - Throws: The function throws an error if: 1: The current user validation fails. 2: The model cannot be encoded properly. 3: There are issues when interacting with Firestore (e.g., network issues or permission errors).
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.1
     
     - Date: August 2024
     */
    func addNewDocument<T: Codable>(_ model: T, forSubCollection collection: CollectionsFB) async throws -> DocumentReference {
        
        let currentUserId = try validateCurrentUser(currentUser).uid
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        let newDocumentEncoded = try UtilsFB.encodeModelFB(model)
        
        //En este caso Firebase genera un ID automaticamente para el nuevo documento con addDocument.
        return try await subCollectionRef.addDocument(data: newDocumentEncoded)
    }
    
    /**
     This function modifies an existing document to a Firestore subcollection based on the given model.
     It uses Firebase to modify the document based on a given DocumentID.
     The operation is asynchronous and throws errors if something goes wrong during the process.
     
     - The function first validates the current user's credentials and retrieves the user's ID.
     - Creates a reference to the specified subcollection for the authenticated user and goes to the specific document based on the ID.
     - The given model is encoded into a Firestore-compatible format.
     - Firebase updates the document using `setData`.

     
     **Example:**
     ```swift
     @Published var model = CategoryModel()
     
     try await Repository().modifyDocument(model, documentId: model.id, forSubCollection: .categories)
     ```
     
     - Parameters:
        - model: A generic parameter `T` conforming to `Codable`. This is the model object that will be encoded and stored as a document in Firestore.
        - documentId: The ID of the document that want to update.
        - collection: A value of the enum type `CollectionsFB` that specifies the Firestore subcollection where the new document will be modified.
        - merge: `true`to add new fields to the actual document existing in Firestore. if `false` just modify existing fields in Firestore.
     
     - Throws: The function throws an error if: 1: The current user validation fails. 2: The model cannot be encoded properly. 3: There are issues when interacting with Firestore (e.g., network issues or permission errors).
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: October 2024
     */
    func modifyDocument<T: Codable>(_ model: T, documentId: String, forSubCollection collection: CollectionsFB, merge: Bool = false) async throws {
        
        let currentUserId = try validateCurrentUser(currentUser).uid
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        let document = subCollectionRef.document(documentId)
        let newDocumentEncoded = try UtilsFB.encodeModelFB(model)
        
        try await document.setData(newDocumentEncoded, merge: merge)
    }
    
    /**
     This function delete an existing document to a Firestore subcollection.
     It uses Firebase to delete the document based on a given DocumentID.
     The operation is asynchronous and throws errors if something goes wrong during the process.
     
     - The function first validates the current user's credentials and retrieves the user's ID.
     - Creates a reference to the specified subcollection for the authenticated user and goes to the specific document based on the ID.
     - Firebase deletes the document using `delete`.

     
     **Example:**
     ```swift
     @Published var model = CategoryModel()
     
     try await Repository().delete(documentId: model.id, forSubCollection: .categories)
     ```
     
     - Parameters:
        - documentId: The ID of the document that want to delete.
        - collection: A value of the enum type `CollectionsFB` that specifies the Firestore subcollection where the new document will be deleted.
     
     - Throws: The function throws an error if: 1: The current user validation fails. 2: The model cannot be encoded properly. 3: There are issues when interacting with Firestore (e.g., network issues or permission errors).
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: October 2024
     */
    func deleteDocument(_ documentId: String, forSubCollection collection: CollectionsFB) async throws {
        
        let currentUserId = try validateCurrentUser(currentUser).uid
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        let document = subCollectionRef.document(documentId)
        
        try await document.delete()
    }
    
    func deleteDocuments(_ documentIds: [String], forSubCollection collection: CollectionsFB) async throws {
        let currentUserId = try validateCurrentUser(currentUser).uid
        let subCollectionRef = UtilsFB.userSubCollectionRef(collection, for: currentUserId)
        
        /*
         The maximum number of writes allowed in a single batch is 500, but note that each usage of FieldValue.serverTimestamp(), FieldValue.arrayUnion(), FieldValue.arrayRemove(), or FieldValue.increment() inside a batch counts as an additional write.
         Unlike transactions, write batches are persisted offline and therefore are preferable when you don’t need to condition your writes on read data.
         */
        let batch = subCollectionRef.firestore.batch()
        
        for documentId in documentIds {
            let document = subCollectionRef.document(documentId)
            batch.deleteDocument(document)
        }
        
        try await batch.commit()
    }
}
