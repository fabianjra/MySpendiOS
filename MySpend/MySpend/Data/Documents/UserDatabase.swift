//
//  UserDatabase.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/9/24.
//

import Firebase

struct UserDatabase {
    
    var currentUser: User? = Auth.auth().currentUser
    
    /**
     addSnapshotListener: Este método de Firestore agrega un listener a un documento, lo que significa que se ejecutará cada vez que ese documento cambie.
     Esto es útil para actualizar automáticamente la UI cuando cambian los datos en la base de datos.
     
     Cuando la función listenUserChanges detecte un cambio en la base de datos, actualizará automáticamente la propiedad categories en el ViewModel,
     y gracias al enlace reactivo de SwiftUI, el View se actualizará en tiempo real.
     
     Con esta implementación, el View se actualizará automáticamente cuando se agreguen, eliminen o modifiquen datos en Firebase Firestore.
     No se tendrá que salir y volver a entrar en la vista para ver los cambios.
     
     **Notes:**
     - Debe utilizarse con: `deinit`. Aquí removemos el listener cuando el ViewModel se destruye, lo cual es una buena práctica para evitar fugas de memoria.
     
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
    func listenUserChanges(listener: @escaping (UserModel?) -> Void) throws -> ListenerRegistration? {
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userDocument = UtilsStore.userRef.document(userId)
        
        var throwableError: Error?
        
        let firestoreListener = userDocument.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                Logs.WriteCatchExeption(error: error)
                throwableError = error
                listener(nil)
                return
            }
            
            guard let documentSnapshot = documentSnapshot,
                  let data = documentSnapshot.data() else {
                Logs.WriteCatchExeption(error: Logs.createError(domain: .databaseStore,
                                                                code: 99,
                                                                description: "Could not get the user document by ID"))
                throwableError = error
                listener(nil)
                return
            }
            
            do {
                let decodedDocument = try UtilsStore.decodeModelFB(data: data, forModel: UserModel.self)
                
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
}
