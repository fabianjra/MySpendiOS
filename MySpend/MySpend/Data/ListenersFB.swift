//
//  ListenersFB.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/9/24.
//

import FirebaseFirestore

public struct ListenersFB {
    
    /**
     addSnapshotListener: Este método de Firestore agrega un listener a un documento, lo que significa que se ejecutará cada vez que ese documento cambie.
     Esto es útil para actualizar automáticamente la UI cuando cambian los datos en la base de datos.
     
     Cuando la función listenUserChanges detecte un cambio en la base de datos, actualizará automáticamente la propiedad categories en el ViewModel,
     y gracias al enlace reactivo de SwiftUI, el View se actualizará en tiempo real.
     
     Con esta implementación, el View se actualizará automáticamente cuando se agreguen, eliminen o modifiquen datos en Firebase Firestore.
     No se tendrá que salir y volver a entrar en la vista para ver los cambios.
     
     **Notes:**
     - Debe utilizarse con: `deinit`. Aquí removemos el listener cuando el ViewModel se destruye, lo cual es una buena práctica para evitar fugas de memoria.
     - Observer Pattern: Escucha los cambios en un documento y notifica a un listener (observador) cada vez que se produce un cambio.
     - Callback Pattern: El método recibe una función de callback (el listener) que será llamada cuando se obtienen los datos.
     
     **Example:**
     ```swift
     private var listener: ListenerRegistration?
     
     func startListeningForCategoryChanges() {
        do {
            listener = try ListenersFB.listenDocument { [weak self] userLoaded in
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
        - listener:Closure que devulve el data obtenido del addSnapshotListener.
     
     - Returns: ListenerRegistration opcional (propiedad de Firebase)
     
     - Throws: Manejo de escepciones por medio de banderas.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Aug 2024
     */
    public func listenDocument<T: Decodable>(forModel modelType: T.Type, document: DocumentReference, listener: @escaping (T?) -> Void) throws -> ListenerRegistration? {
        var throwableError: Error?
        
        let firestoreListener = document.addSnapshotListener { documentSnapshot, error in
            
            if let error = error {
                Logs.WriteCatchExeption(error: error)
                throwableError = error
                listener(nil)
                return
            }
            
            guard let documentSnapshot = documentSnapshot, let data = documentSnapshot.data() else {
                let error = Logs.createError(domain: .listenerDocumentFB, error: .notGetDataFromDocument)
                Logs.WriteCatchExeption(error: error)
                throwableError = error
                listener(nil)
                return
            }
            
            do {
                let decodedDocument = try UtilsFB.decodeModelFB(data: data, forModel: modelType)
                
                listener(decodedDocument)
            } catch {
                Logs.WriteCatchExeption(error: error)
                throwableError = error
                listener(nil)
            }
        }
        
        if let error = throwableError {
            throw error
        }
        
        return firestoreListener
    }
    
    /**
     This function listens for changes in a Firestore collection and passes the resulting documents and errors (if any) to the provided closure.
     It does not need to throw an error because the error handling is managed internally.
     In case of any error during the listening process, the error is logged and passed to the closure, while an empty list of documents is returned.
     
     The function uses addSnapshotListener to asynchronously listen for changes in a Firestore collection.
     When a change occurs (or when the initial data is fetched), the listener is triggered, providing either the documents or an error, depending on the result.
     Errors are handled internally and propagated through the listener closure, avoiding the need for throwing errors.
     
     **Example:**
     ```swift
     private var listener: ListenerRegistration?
     
     func startListeningForCategoryChanges() {
        do {
            listener = ListenersFB().listenCollection(collection: collectionRef) { [weak self] documentsSnapshots, error in
            
            categories = documentsSnapshots.compactMap { documentSnapshot in
                let data = documentSnapshot.data()
            
                if let data = data {
                    let decodedModel = try? UtilsFB.decodeModelFB(data: data, forModel: CategoryModel.self)
                    
                    if var decodedModel = decodedModel {
                        decodedModel.id = documentSnapshot.documentID
                        return decodedModel
                    }
                }
                
                Logs.WriteMessage("Error al decodificar el documento y pasarlo al Modelo")
                return nil
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
        - collection:A CollectionReference that points to the Firestore collection you want to observe.
        - listener: A closure that receives two parameters: 1: An array of DocumentSnapshot representing the documents in the collection. 2: An Error? that will be nil if no error occurred or will contain an error object if something went wrong during the snapshot retrieval.
     
     - Returns: Returns a ListenerRegistration? object that represents the Firestore listener. You can use this object to stop listening for changes by calling its remove() method.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: October 2024
     */
    public func listenCollection(collection: CollectionReference, listener: @escaping ([DocumentSnapshot], Error?) -> Void) -> ListenerRegistration? {
        let firestoreListener = collection.addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                Logs.WriteCatchExeption(error: error)
                listener([], error)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                let error = Logs.createError(domain: .listenerCollectionFB, error: .notGetDataFromCollection)
                Logs.WriteCatchExeption(error: error)
                listener([], error)
                return
            }
            
            listener(querySnapshot.documents, nil)
        }
        
        return firestoreListener
    }
    
    /**
     This function listens for real-time changes in a Firestore collection and returns only the changes that occurred between the previous snapshot and the current one.
     The function utilizes Firestore's addSnapshotListener to monitor changes in the specified collection, and it passes an array of DocumentChange objects (which represent the changes in the collection) or an error, if one occurs, to the provided listener closure.
     
     - The function starts a listener using Firestore's addSnapshotListener. This listener observes changes to the specified Firestore collection in real-time.
     - In case of an error during the retrieval of the data, the error is logged, and an empty array with the error is returned via the listener closure.
     - If there’s no error but no valid querySnapshot was retrieved, a custom error is created and returned.
     - The function checks whether the querySnapshot is empty or if no document changes are present. If so, it calls the listener with an empty array, meaning no changes have occurred.
     - Otherwise, it retrieves the list of changes (documentChanges) from the snapshot and returns it via the listener closure.


     
     **Example:**
     ```swift
     self.listener = ListenersFB().listenCollectionChanges(collection: collectionRef) { [weak self] documentChange, error in
     guard let self = self else { return }
    
     if let error = error {
        print("Error listening to changes: \(error.localizedDescription)")
        return
     }
    
    for change in documentChange {
        switch change.type {
        case .added:
            // Handle added document
        case .modified:
            // Handle modified document
        case .removed:
            // Handle removed document
        }
     }
     ```
     
     - Parameters:
        - collection:The Firestore collection that is being monitored for changes. A reference to a specific Firestore collection from which data is retrieved in real-time.
        - listener: A closure that gets called each time changes occur in the collection.
     
     - Returns: Returns a ListenerRegistration object that represents the active Firestore listener. This object can be used to stop the listener when it's no longer needed. If no listener is registered, it returns nil.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: October 2024
     */
    public func listenCollectionChanges(collection: CollectionReference, listener: @escaping ([DocumentChange], Error?) -> Void) -> ListenerRegistration? {
        let firestoreListener = collection.addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                Logs.WriteCatchExeption(error: error)
                listener([], error)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                let error = Logs.createError(domain: .listenerCollectionChangesFB, error: .notGetDataFromCollectionChanges)
                Logs.WriteCatchExeption(error: error)
                listener([], error)
                return
            }

            listener(querySnapshot.documentChanges, nil)
        }
        
        return firestoreListener
    }
    
}
