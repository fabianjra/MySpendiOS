//
//  CategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import FirebaseFirestore

class CategoryViewModel: BaseViewModel {
    
    @Published var categories: [CategoryModelFB]
    @Published var categoryType: TransactionType = .expense
    
    // MARK: EDIT
    @Published var isEditing: Bool = false
    @Published var selectedCategories = Set<CategoryModelFB>()
    
    // MARK: SORT
    @Published var sortCategoriesBy = UserDefaultsManager.sorCategories
    
    // MARK: MODALS AND POPUPS
    @Published var showNewCategoryModal = false
    @Published var showModifyCategoryModal = false
    
    @Published var showAlertDelete = false
    @Published var showAlertDeleteMultiple = false
    
    //init for Canvas Previews.
    init(categories: [CategoryModelFB] = []) {
        self.categories = categories
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
                
                if documentsChange.isEmpty {
                    categories.removeAll()
                } else {
                    for change in documentsChange {
                        switch change.type {
                            
                            //La primera vez que se llama al listener, se reciben todos los documentos como "added", y después solo se reciben las diferencias.
                        case .added:
                            let data = change.document.data()
                            
                            do {
                                var decodedDocument = try UtilsFB.decodeModelFB(data: data, forModel: CategoryModelFB.self)
                                
                                // If the new category is already with same ID in the categories array, don't add it again.
                                if categories.contains(where: { $0.id == change.document.documentID }) {
                                    let error = Logs.createError(domain: .listenerCategories, error: .addDuplicatedDocument(change.document.documentID))
                                    Logs.WriteCatchExeption(Errors.addDuplicatedDocument(change.document.documentID).errorDescription, error: error)
                                } else {
                                    decodedDocument.id = change.document.documentID
                                    categories.append(decodedDocument)
                                }
                            } catch {
                                Logs.WriteCatchExeption(Errors.decodeDocument(change.document.documentID).errorDescription, error: error)
                            }
                            
                        case .modified:
                            if let index = categories.firstIndex(where: { $0.id == change.document.documentID }) {
                                let data = change.document.data()
                                
                                if var decodedDocument = try? UtilsFB.decodeModelFB(data: data, forModel: CategoryModelFB.self) {
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
    }
    
    func deleteCategory(_ model: CategoryModelFB) async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteMltipleCategories() async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                let selectedDocumentIds = self.selectedCategories.map { $0.id }

                try await Repository().deleteDocuments(selectedDocumentIds, forSubCollection: .categories)
                
                self.selectedCategories.removeAll()
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    /**
     Updates the sort selection to store in UserDefaults.
     */
    func updateSelectedSort() {
        UserDefaultsManager.sorCategories = sortCategoriesBy
    }
    
    /**
     Deletes the sort selection object in UserDefaults.
     */
    func resetSelectedSort() {
        UserDefaultsManager.removeValue(for: .sortCategories)
        sortCategoriesBy = UserDefaultsManager.sorCategories
    }
}
