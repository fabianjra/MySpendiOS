//
//  CategoriesDatabase.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/9/24.
//

import FirebaseAuth
import Firebase

struct CategoriesDatabase: UserValidationProtocol {
    
    private var currentUser: User? = AuthFB().currentUser
    
    /**
     Only for fetch data once.
     
     - Authors: Fabian Rodriguez.
     
     - Date: August 2024
     */
    func getCategory(forId documentID: String) async throws -> CategoryModel? {
        if var category = try await Repository().getDocument(forId: documentID, forModel: CategoryModel.self, forSubCollection: .categories) {
            category.id = documentID
            category.id.isEmptyOrWhitespace ? category.id = documentID : ()
            
            return category
        }
        
        return nil
    }
    
    /**
     Only for fetch data once.
     
     - Authors: Fabian Rodriguez.
     
     - Date: August 2024
     */
    private func getCategories() async throws -> [CategoryModel] {
        
        let userId = try validateCurrentUser(currentUser).uid
        let subCollectionRef = UtilsFB.userSubCollectionRef(.categories, for: userId)
        let subCollectionQuery = try await subCollectionRef.getDocuments()
        
        if subCollectionQuery.isEmpty || subCollectionQuery.documents.isEmpty {
            return []
        }
        
        var categoryArray: [CategoryModel] = []
        
        for document in subCollectionQuery.documents {
            let data = document.data()
            
            var decodedDocument = try UtilsFB.decodeModelFB(data: data, forModel: CategoryModel.self)
            decodedDocument.id = document.documentID
            
            categoryArray.append(decodedDocument)
        }

        return categoryArray
    }
}




// *******************************
// PRUEBAS:
// *******************************


// ESTO VA PARA EL VIEWMODEL DE CATEGOREIS PORQUE AHI ESTA EL LISTENER:
private struct CategoryCollection_PRUEBAS {

    var categories: [CategoryModel]

    // Inicializador que recibe un `QuerySnapshot` y mapea los documentos a modelos de categoría
    init(snapshot: QuerySnapshot) throws {
        self.categories = snapshot.documents.compactMap { document in

            // Intentar hacer el decoding de cada documento a CategoryModel
            let category = try? document.data(as: CategoryModel.self)

            // Si el decoding fue exitoso, le asignamos el ID del documento
            if var category = category {
                category.id = document.documentID
                return category
            } else {
                //Logs.WriteCatchExeption(error: Logs.createError(domain: .categoriesDatabase, code: 99, description: "Error al decodificar el documento a CategoryModel"))
                return nil
            }
        }
    }
}


private struct CategoriesDatabase_PRUEBAS {
    
    var currentUser: User? = Auth.auth().currentUser
    
    func addNewCategory_PRUEBAS_NUEVO_MODELO() async throws {
        
        
        print("//////////////")
        print("")
        
        print(CategoryModel.CodingKeys.categoryType.rawValue) //obtiene el valor de string de codingKey
        print(CategoryModel.CodingKeys.categoryType.stringValue) //obtiene el valor de string de codingKe
        
        print("")
        print("//////////////")
        
        
        // ******************************************************************
        //LEER DATA:
        
        //Con WHere:
        let conWhere = UtilsFB.db.collection("users")
            .document(currentUser!.uid)
            .collection("categories")
            .whereField("icon", isEqualTo: "nuevaCat")
        
        print("CON WHERE:")
        print(conWhere)
        print("***********")
        
        
        let categoriesRef = UtilsFB.db.collection("users").document(currentUser!.uid).collection("categories")
        
        
        // ******************************************************************
        //REMOVER:
        let documento = categoriesRef.document()
        
        let categoriesSnapshot = try await categoriesRef.getDocuments()
        
        
        for snapshot in categoriesSnapshot.documents {
            
            print("categoryId: " + snapshot.documentID)
            print("categoryData: \(snapshot.data())")
        }
        
        
        // PASANDO TODA LA SUBCOLECCION A UN MODELO:
        do {
            let categoriesSnapshot = try await categoriesRef.getDocuments()
            
            print("snapshots:")
            for item in categoriesSnapshot.documents {
                print(item.data())
            }
            
            print(" ")
            
            // Usamos el nuevo modelo `CategoryCollection` para decodificar toda la subcolección de categorías
            let categoryCollection = try CategoryCollection_PRUEBAS(snapshot: categoriesSnapshot)
            
            // Ahora puedes acceder directamente a la lista de categorías decodificadas
            let categories = categoryCollection.categories
            print("Categorías obtenidas: \(categories)")
            
        } catch {
            print("Error al obtener las categorías: \(error.localizedDescription)")
        }
        
        
        
        
        
        let newCategoryModel = CategoryModel(id: UUID().uuidString, icon: "new", name: "new", categoryType: .expense)
        let newCategoryModelData = try UtilsFB.encodeModelFB(newCategoryModel)
        
        
        // ******************************************************************
        // AGREGAR:
        
        //A veces no hay un ID significativo para el documento y es más conveniente dejar que Cloud Firestore genere automáticamente un ID, con addDocument.
        let _ = try await UtilsFB.db.collection("users").document(currentUser!.uid).collection("categories").addDocument(data: newCategoryModelData)
        
        
        //String del ID de la nueva categiria
        let _ = documento.documentID
        
        
        
        // ******************************************************************
        // NEW DATA WITH MERGE:
        
        let newCategoryModel2 = CategoryModel(id: UUID().uuidString, icon: "new 2", name: "new 2", categoryType: .expense)
        let newCategoryModel2Data = try UtilsFB.encodeModelFB(newCategoryModel2)
        
        // Update one field, creating the document if it does not exist.
        //Si no sabes si el documento existe, no utilices la opción de combinar los datos nuevos con cualquier documento existente, para así evitar reemplazar documentos completos.
        try await UtilsFB.db.collection("users").document(currentUser!.uid).setData(newCategoryModel2Data, merge: true)
        
        
        
        // ******************************************************************
        // UPADATE:
        
        //Para actualizar algunos campos de un documento sin reemplazarlo por completo, usa los métodos update() específicos para cada lenguaje:
        try await documento.updateData([CategoryModel.CodingKeys.name.stringValue: "Updated name"])
        
        
        
        //Si tu documento contiene objetos anidados, puedes usar la “notación de puntos” para hacer referencia a los campos anidados dentro del documento cuando llames a update():
        // Create an initial document to update.
        let frankDocRef = UtilsFB.db.collection("users").document("frank")
        do {
            try await frankDocRef.setData([
                "name": "Frank",
                "favorites": [ "food": "Pizza", "color": "Blue", "subject": "recess" ],
                "age": 12
            ])
            
            // To update age and favorite color:
            try await frankDocRef.updateData([
                "age": 13,
                "favorites.color": "Red"
            ])
            print("Document successfully updated")
        } catch {
            print("Error updating document: \(error)")
        }
        
        
        // ******************************************************************
        // ARRAYS:
        
        //Actualiza elementos de un array
        //Si tu documento contiene un campo de array, puedes usar arrayUnion() y arrayRemove() para agregar y quitar elementos. Con arrayUnion(), se pueden agregar elementos a un array, pero solo si aún no están presentes. arrayRemove() permite quitar todas las instancias de cada elemento dado.
        
        let washingtonRef = UtilsFB.db.collection("cities").document("DC")
        
        // Atomically add a new region to the "regions" array field.
        try await washingtonRef.updateData([
            "regions": FieldValue.arrayUnion(["greater_virginia"])
        ])
        
        // Atomically remove a region from the "regions" array field.
        try await washingtonRef.updateData([
            "regions": FieldValue.arrayRemove(["east_coast"])
        ])
        
    }
    
}
