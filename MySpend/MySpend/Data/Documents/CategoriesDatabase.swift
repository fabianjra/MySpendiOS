//
//  CategoriesDatabase.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/9/24.
//

import Firebase

struct CategoriesDatabase {
    
    var currentUser: User? = Auth.auth().currentUser
    
    func addNewCategory(categoryModel: CategoryModel) async throws {
        
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userRefDocument = UtilsStore.userCollectionReference.document(userId)
        
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
    
    private func getCategories() async throws -> [CategoryModel] {
        guard let userId = currentUser?.uid else {
            throw ConstantMessages.userNotLoggedIn
        }
        
        let userDocument = UtilsStore.userCollectionReference.document(userId)
        
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
