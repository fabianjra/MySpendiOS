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
    
    func fetchData() {
        
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator. Ejem: Dispositivo fisico.
        #endif

        performWithCurrentUser { currentUser in
            
            let collectionRef = UtilsFB.userSubCollectionRef(.categories, for: currentUser.uid)
            
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
}
