//
//  CategoriesViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import FirebaseFirestore

class CategoriesViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel]
    
    init(categories: [CategoryModel] = []) {
        self.categories = categories
    }
    
    private func getCategoriesOnce() async {
        
        do {
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator. Ejem: Dispositivo fisico.
            categories = try await AllDatabaseStore().getCategories()
        #endif
        } catch {
            errorMessage = error.localizedDescription
        }
    }
 
    private var listener: ListenerRegistration?
    
    func onAppear() {
        
        guard let userId = AuthFB().currentUser?.uid else {
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return
        }
        
        let userDocument = UtilsStore.userCollectionReference.document(userId)
        
        do {
            listener = try Repository().listenDocumentChanges(forModel: UserModel.self, document: userDocument) { [weak self] userLoaded in
                guard let self = self else {
                    Logs.WriteMessage("GUARD evito crear el listenCategoriesChanges ya que no se logro obtener self.")
                    return
                }
                
                self.categories = userLoaded?.categoryList ?? []
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    deinit {
        listener?.remove()
    }
}
