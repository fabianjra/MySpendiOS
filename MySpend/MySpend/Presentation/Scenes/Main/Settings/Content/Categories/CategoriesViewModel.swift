//
//  CategoriesViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import FirebaseFirestore

class CategoriesViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModel]
    @Published var errorMessage: String = ""
    
    init(categories: [CategoryModel] = []) {
        self.categories = categories
    }
    
    //TODO: Forma de obtener categorias una unica vez. Descartado. Utilizar Listener.
    private func getCategories() async {
        
        do {
        //#if DEBUG || TARGET_OS_SIMULATOR
        #if targetEnvironment(simulator)
            //No cargar datos cuando se esta corriendo en simulador.
            categories = try await DatabaseStore().getCategories()
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator.
            categories = try await DatabaseStore().getCategories()
        #endif
        } catch {
            errorMessage = error.localizedDescription
        }
    }
 
    private var listener: ListenerRegistration?
    
    func startListeningForCategoryChanges() {
        do {
            listener = try DatabaseStore().listenCategoriesChanges { [weak self] categoriesLoaded in
                guard let self = self else {
                    Logs.WriteMessage("GUARD evito crear el listenCategoriesChanges ya que no se logro obtener self.")
                    return
                }
                
                self.categories = categoriesLoaded
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    deinit {
        listener?.remove()
    }
}
