//
//  CategoriesViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import FirebaseFirestore

class CategoriesViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel]
    
    //init for previews.
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
            let userDocument = UtilsStore.userCollectionReference.document(currentUser.uid)
            
            do {
                self.listener = try Repository().listenDocumentChanges(forModel: UserModel.self, document: userDocument) { [weak self] userLoaded in
                    guard let self = self else {
                        Logs.WriteMessage("GUARD evito crear el listenDocumentChanges ya que no se logro obtener self.")
                        return
                    }
                    
                    categories = userLoaded?.categoryList ?? []
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
}
