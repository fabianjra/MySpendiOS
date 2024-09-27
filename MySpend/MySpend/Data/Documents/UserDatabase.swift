//
//  UserDatabase.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/9/24.
//

struct UserDatabase {
    
    func storeUserDocument(forUser user: UserModel) async throws {
        
        let encodedUser = try UtilsStore.encodeModelFB(user)
        let createRequest = UtilsStore.userCollectionReference.document(user.id)
        
        try await createRequest.setData(encodedUser)
    }

}
