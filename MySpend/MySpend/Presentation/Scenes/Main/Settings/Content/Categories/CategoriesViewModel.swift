//
//  CategoriesViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import FirebaseFirestore

class CategoriesViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel]
    
    //init for Canvas Previews.
    init(categories: [CategoryModel] = []) {
        self.categories = categories
    }
    
    private var listener: ListenerRegistration?
    
    func fetchData() async {
        
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator. Ejem: Dispositivo fisico.
        #endif

        performWithCurrentUser { currentUser in
            
            let collectionRef = UtilsFB.userSubCollectionRef(.categories, for: currentUser.uid)
            
            self.listener = ListenersFB().listeCollectionChanges(collection: collectionRef) { [weak self] documentChange, error in

                guard let self = self else {
                    Logs.WriteMessage("Guard evito crear el listener ya que no se logro obtener self")
                    return
                }
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    Logs.WriteCatchExeption(error: error)
                    return
                }
                
                for change in documentChange {
                    switch change.type {
                        
                        //La primera vez que se llama al listener, se reciben todos los documentos como "added", y después solo se reciben las diferencias.
                    case .added:
                        let data = change.document.data()
                        let decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: CategoryModel.self)
                        
                        if var decodedDocument = decodedDocument {
                            //if !categories.contains(where: { $0.id == change.document.documentID }) { } //Permite validar que no se dupliquen items.
                            decodedDocument.id = change.document.documentID
                            categories.append(decodedDocument)
                        }
                        
                    case .modified:
                        if let index = categories.firstIndex(where: { $0.id == change.document.documentID }) {
                            let data = change.document.data()
                            
                            if var decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: CategoryModel.self) {
                                decodedDocument.id = change.document.documentID
                                categories[index] = decodedDocument
                            }
                        }
                        
                    case .removed:
                        categories.removeAll(where: { $0.id == change.document.documentID })
                        
                    default:
                        Logs.WriteMessage("Nothing modified in the documentChange")
                    }
                }
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
    
    
    //***************************
    //TODO: ORIGINAL - SIN USO.
    //***************************
    func fetchData_ORIGINAL() async throws {
        performWithCurrentUser { currentUser in
            
            let collectionRef = UtilsFB.userSubCollectionRef(.categories, for: currentUser.uid)
            
            self.listener = ListenersFB().listenCollection(collection: collectionRef) { [weak self] documentsSnapshots, error in
                
                guard let self = self else {
                    Logs.WriteMessage("Guard evito crear el listener ya que no se logro obtener self")
                    return
                }
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    Logs.WriteCatchExeption(error: error)
                    return
                }
                
                //TODO: Cambiar logica ya que cada vez que se hace un cambio, recorre todo la coleccion y la vuelve a llenar:
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
                    return nil //En caso de que data o decodedModel sea nil, los ignora.
                }
            }
        }
    }
    
    
    
}
