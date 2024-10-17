//
//  ResumeViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import FirebaseFirestore

class ResumeViewModel: BaseViewModel {
    
    @Published var model = Resume()
    @Published var showNewTransactionModal = false
    @Published var selectedTab: TabViewIcons = .resume
    @Published var navigateToHistory: Bool = false
    
    //init for Canvas Previews.
    init(model: Resume = Resume()) {
        self.model = model
    }
    
    private var listener: ListenerRegistration?
    
    func onAppear() {
        performWithCurrentUser { currentUser in
            self.model.userName = currentUser.displayName ?? ""
        }
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
                    Logs.WriteCatchExeption(error: error)
                    return
                }
                
                for change in documentsChange {
                    switch change.type {
                        
                        //La primera vez que se llama al listener, se reciben todos los documentos como "added", y después solo se reciben las diferencias.
                    case .added:
                        let data = change.document.data()
                        let decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: TransactionModel.self)
                        
                        if var decodedDocument = decodedDocument {
                            
                            //Permite validar que no se dupliquen items.
                            if !model.transactions.contains(where: { $0.id == change.document.documentID }) {
                                decodedDocument.id = change.document.documentID
                                model.transactions.append(decodedDocument)
                            }
                        }
                        
                    case .modified:
                        if let index = model.transactions.firstIndex(where: { $0.id == change.document.documentID }) {
                            let data = change.document.data()
                            
                            if var decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: TransactionModel.self) {
                                decodedDocument.id = change.document.documentID
                                model.transactions[index] = decodedDocument
                            } else {
                                Logs.WriteMessage("Error al decodificar el documento y pasarlo al Modelo")
                            }
                        }
                        
                    case .removed:
                        model.transactions.removeAll(where: { $0.id == change.document.documentID })
                        
                    default:
                        Logs.WriteMessage("Nothing modified in the documentChange")
                    }
                }
                
                //TODO: Refactorizar, ya que se recorrera de nuevo con cada cambio.
                // Se debe borrar la cantidad en el onAppear porque sino seguria sumandose infinitamente.
                model.totalBalance = .zero
                model.totalBalanceFormatted = ConstantCurrency.zeroAmoutString.addCurrencySymbol()
                
                for item in model.transactions {
                    model.totalBalance += item.amount
                }
                model.totalBalanceFormatted = model.totalBalance.convertAmountDecimalToString().addCurrencySymbol()
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
    
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
    
    
    
    
    //***************************
    //TODO: ORIGINAL - SIN USO.
    //***************************
    func fetchData_ORIGINAL() {

        performWithCurrentUser { currentUser in
            self.model.userName = currentUser.displayName ?? ""
            
            let collectionRef = UtilsFB.userSubCollectionRef(.transactions, for: currentUser.uid)
            
            self.listener = ListenersFB().listenCollection(collection: collectionRef) { [weak self] documentsSnapshot, error in
                
                guard let self = self else {
                    Logs.WriteMessage("Guard evito crear el listener ya que no se logro obtener self")
                    return
                }
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    Logs.WriteCatchExeption(error: error)
                    return
                }
                
                model.transactions = documentsSnapshot.compactMap { documentSnapshot in
                    let data = documentSnapshot.data()
                    
                    if let data = data {
                        let decodedModel = try? UtilsFB.decodeModelFB(data: data, forModel: TransactionModel.self)
                        
                        if var decodedModel = decodedModel {
                            decodedModel.id = documentSnapshot.documentID
                            return decodedModel
                        }
                    }
                    
                    Logs.WriteMessage("Error al decodificar el documento y pasarlo al Modelo")
                    return nil //En caso de que data o decodedModel sea nil, los ignora.
                }
                
                // Se debe borrar la cantidad en el onAppear porque sino seguria sumandose infinitamente.
                model.totalBalance = .zero
                model.totalBalanceFormatted = ConstantCurrency.zeroAmoutString.addCurrencySymbol()
                
                for item in model.transactions {
                    model.totalBalance += item.amount
                    model.totalBalanceFormatted = model.totalBalance.convertAmountDecimalToString().addCurrencySymbol()
                }
            }
        }
    }
}
