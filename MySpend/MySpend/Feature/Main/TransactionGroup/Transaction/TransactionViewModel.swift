//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import FirebaseFirestore

class TransactionViewModel: BaseViewModel {
    
    @Published var userName: String = ""
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    
    // MARK: TRANSACTIONS
    @Published var transactions: [TransactionModelFB]
    @Published var groupedTransactions: UtilsCurrency.groupedTransactions = []
    
    //init for Canvas Previews.
    init(transactions: [TransactionModelFB] = []) {
        self.transactions = transactions
    }
    
    func onAppear() {
        performWithCurrentUser { currentUser in
            guard let displayName = currentUser.displayName else { return }
            self.userName = displayName
        }
    }
    
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func fetchData() {
        
        //#if DEBUG || TARGET_OS_SIMULATOR
#if targetEnvironment(simulator)
        //No cargar datos cuando se esta corriendo en simulador.
#else
        //Otra accion en caso de que no sea DEBUG o Simulator. Ejem: Dispositivo fisico.
#endif
        
        performWithCurrentUser { currentUser in
            let collectionRef = UtilsFB.userSubCollectionRef(.transactions, for: currentUser.uid)
            
            self.listener = ListenersFB().listenCollectionChanges(collection: collectionRef) { [weak self] documentsChange, error in
                
                guard let self = self else {
                    Logs.WriteMessage("Guard evito crear el listener ya que no se logro obtener self")
                    return
                }
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    Logs.CatchException(error)
                    return
                }
                
                //TODO: Revisar:
                /*
                 NOTA 1:
                 Revisar la implementacion de un Protocol HasStringID para los modelos de CategoryModel y TransactionModel y asi hacer todo generico del lado del ListenersFB().
                 El problema es que se pasaria un array para modificarlo del otro lado, lo que implica pasar un ValueType y es inmutable,
                 por lo que se tendria que crear una copia del otro lado y devolver esa copia para hacerle encima al array de este ViewModels.
                 Lo mejor es dejarlo como esta por ahora, ya que crear una instancia nueva del array en el otro lado impica costo de rendimiento, ya que seria en cada cambio.
                 
                 NOTA 2:
                 Lo que se podria hacer del otro lado es obtener el valor del documento modificado, aplicarle el id y devolverlo y hacerlo todo de forma generica y de este lado solo
                 hacer el append o actualizacion del mismo. Para los remove, no se puede porque implica modificar el array el cual es inmutable.
                 */
                if documentsChange.isEmpty {
                    transactions.removeAll()
                } else {
                    for change in documentsChange {
                        switch change.type {
                            
                            //La primera vez que se llama al listener, se reciben todos los documentos como "added", y después solo se reciben las diferencias.
                        case .added:
                            let data = change.document.data()
                            
                            do {
                                var decodedDocument = try UtilsFB.decodeModelFB(data: data, forModel: TransactionModelFB.self)
                                
                                // If the new transaction is already with same ID in the transaction array, don't add it again.
                                if transactions.contains(where: { $0.id == change.document.documentID }) {
                                    let error = Logs.createError(domain: .listenerTransactions, error: .addDuplicatedDocument(change.document.documentID))
                                    Logs.CatchException(error)
                                } else {
                                    decodedDocument.id = change.document.documentID
                                    transactions.append(decodedDocument)
                                }
                            } catch {
                                Logs.CatchException(error)
                            }
                            
                        case .modified:
                            if let index = transactions.firstIndex(where: { $0.id == change.document.documentID }) {
                                let data = change.document.data()
                                
                                if var decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: TransactionModelFB.self) {
                                    decodedDocument.id = change.document.documentID
                                    transactions[index] = decodedDocument
                                } else {
                                    Logs.WriteMessage("Error al decodificar el documento y pasarlo al Modelo")
                                }
                            }
                            
                        case .removed:
                            transactions.removeAll(where: { $0.id == change.document.documentID })
                            
                        default:
                            Logs.WriteMessage("Nothing modified in the documentChange with ID: \(change.document.documentID).")
                        }
                    }
                }
                
                groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
            }
        }
        
        // Only to show Mock values on the Canvas Preview.
        if UtilsUI.isRunningOnCanvasPreview {
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
        }
    }
    
    //TODO: Implementar o borrar.
    private func PREUBAS_CAMPOS_DE_FIREBASE() {
        
        let authViewModel = AuthViewModel()
        
        if let user = authViewModel.currentUser {
            
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            
            let _: String = user.providerID
            let _: String = user.uid
            let _: String? = user.displayName
            let _: URL? = user.photoURL
            let _: String? = user.email
            
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
        }
    }
}
