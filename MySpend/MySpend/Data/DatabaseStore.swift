//
//  DatabaseStore.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Firebase

struct DatabaseStore {
    
    var currentUser: User? = Auth.auth().currentUser
    
    //**************************************************************
    // MARK: TRANSACCIONES
    //**************************************************************
    
    /**
     El return nil en el bloque runTransaction no afecta la capacidad de capturar errores. Se utiliza para indicar que el valor retornado por la transacción no es necesario para la lógica de la aplicación. Los errores se manejan usando el parámetro errorPointer y el bloque catch externo.
     
     1.Transacciones en Firestore:
     
     - Cuando usas runTransaction, estás realizando una operación atómica que puede leer y escribir datos en Firestore. La transacción se asegura de que las lecturas y escrituras sean coherentes, incluso en entornos concurrentes.
     - El resultado del bloque de transacción (el valor retornado) no es usado directamente para verificar si la transacción fue exitosa o no. La principal responsabilidad del bloque de transacción es realizar las operaciones necesarias y manejar cualquier error que pueda ocurrir durante el proceso.
     
     2. Manejo de Errores:
     
     - Si ocurre un error dentro del bloque de transacción, puedes capturarlo y manejarlo usando el parámetro errorPointer, como en el código. Este error será propagado fuera del bloque runTransaction y podrá ser capturado por el bloque catch externo.
     - return nil simplemente indica que no se está produciendo un valor de resultado significativo. La transacción se considera exitosa si no se producen errores y los datos se escriben correctamente en Firestore.
     
     - Authors: Fabian Rodriguez.
     
     - Date: Aug 2024
     */
    func addNewTransaction(transactionModel: TransactionModel) async throws {
        
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userRefDocument = UtilsStore.userRef.document(userId)
        
        do {
            let _ = try await UtilsStore.db.runTransaction { (transaction, errorPointer) -> Any? in
                
                let userDocument: DocumentSnapshot
                
                do {
                    userDocument = try transaction.getDocument(userRefDocument)
                } catch let error as NSError {
                    /// Al usar return nil, estás indicando a Firestore que la transacción no debe completarse en ese intento, y Firestore manejará los reintentos automaticamente por debejo.
                    errorPointer?.pointee = error
                    Logs.WriteCatchExeption(error: error)
                    return nil
                }
                
                var user: UserModel
                
                do {
                    user = try userDocument.data(as: UserModel.self)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    Logs.WriteCatchExeption(error: error)
                    return nil
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
                    return nil
                }
                
                return nil
            }
        } catch {
            /*
             Cuando se usa runTransaction de Firestore, los errores que ocurren dentro del bloque de transacción son manejados
             y propagados a través del parámetro errorPointer.
             Estos errores se capturan en el bloque catch externo de esta funcion addNewTransaction.
             Si no se vuelve a lanzar el error (throw error), el error se consume y no se propaga más allá de la función,
             lo que puede hacer que el error no sea manejado adecuadamente por la parte de tu código que llama a addNewTransaction.
             */
            Logs.WriteCatchExeption(error: error)
            throw error
        }
    }
    
    func getTransactions() async throws -> [TransactionModel] {
        guard let userId = currentUser?.uid else {
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
    
    //**************************************************************
    // MARK: CATEGORIES
    //**************************************************************
    
    func addNewCategory(categoryModel: CategoryModel) async throws {
        
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userRefDocument = UtilsStore.userRef.document(userId)
        
        do {
            let _ = try await UtilsStore.db.runTransaction { (transaction, errorPointer) -> Any? in
                
                let userDocument: DocumentSnapshot
                
                do {
                    userDocument = try transaction.getDocument(userRefDocument)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    Logs.WriteCatchExeption(error: error)
                    return nil
                }
                
                var user: UserModel
                
                do {
                    user = try userDocument.data(as: UserModel.self)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    Logs.WriteCatchExeption(error: error)
                    return nil
                }
                
                if user.categoryList == nil {
                    user.categoryList = []
                }
                
                user.categoryList?.append(categoryModel)
                
                do {
                    try transaction.setData(from: user, forDocument: userRefDocument)
                } catch let error {
                    errorPointer?.pointee = error as NSError
                    Logs.WriteCatchExeption(error: error)
                    return nil
                }
                
                return nil
            }
        } catch {
            Logs.WriteCatchExeption(error: error)
            throw error
        }
    }
    
    func getCategories() async throws -> [CategoryModel] {
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userDocument = UtilsStore.userRef.document(userId)
        
        let documentSnapshot = try await userDocument.getDocument()
        
        guard let data = documentSnapshot.data() else {
            return []
        }
        
        let decodedDocument = try UtilsStore.decodeModelFB(data: data, forModel: UserModel.self)
        
        guard let categories = decodedDocument.categoryList else {
            return []
        }
        
        return categories
    }
}
