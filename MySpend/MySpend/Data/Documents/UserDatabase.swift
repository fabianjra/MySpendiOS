//
//  UserDatabase.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/9/24.
//

struct UserDatabase {
    
    func storeUserDocument(forUser user: UserModel) async throws {
        
        let encodedUser = try UtilsFB.encodeModelFB(user)
        let createRequest = UtilsFB.userCollectionRef.document(user.id)
        
        try await createRequest.setData(encodedUser)
    }

}
