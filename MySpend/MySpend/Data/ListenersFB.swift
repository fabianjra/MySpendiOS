//
//  ListenersFB.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/9/24.
//

import Firebase
import FirebaseFirestore

struct ListenersFB {
    
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
     - listener:Closure que devulve el data obtenido del addSnapshotListener.
     
     - Returns: ListenerRegistration opcional (propiedad de Firebase)
     
     - Throws: Manejo de escepciones por medio de banderas.
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: Aug 2024
     */
    public func listenDocumentChanges<T: Decodable>(forModel modelType: T.Type, document: DocumentReference, listener: @escaping (T?) -> Void) throws -> ListenerRegistration? {
        var throwableError: Error?
        
        let firestoreListener = document.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                Logs.WriteCatchExeption(error: error)
                throwableError = error
                listener(nil)
                return
            }
            
            guard let documentSnapshot = documentSnapshot,
                  let data = documentSnapshot.data() else {
                let error = Logs.createError(domain: .databaseStore,
                                             code: 99,
                                             description: "Could not get data from documentSnapshot")
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
    
    
    public func listenCollectionChanges(collection: CollectionReference, listener: @escaping ([DocumentSnapshot], Error?) -> Void) -> ListenerRegistration? {
        let firestoreListener = collection.addSnapshotListener { querySnapshot, error in
            if let error = error {
                Logs.WriteCatchExeption(error: error)
                listener([], error)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                let error = Logs.createError(domain: .databaseStore,
                                             code: 99,
                                             description: "Could not get data from collection snapshot")
                Logs.WriteCatchExeption(error: error)
                listener([], error)
                return
            }
            
            listener(querySnapshot.documents, nil)
        }
        
        return firestoreListener
    }
    
    
}