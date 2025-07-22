//
//  UtilsFB.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/24.
//
import Firebase

struct UtilsFB {
    
    static var db = Firestore.firestore()
    static var userCollectionRef = db.collection(CollectionsFB.users.rawValue)
    
    static func userSubCollectionRef(_ collection: CollectionsFB, for userID: String) -> CollectionReference {
        return userCollectionRef
            .document(userID)
            .collection(collection.rawValue)
    }

    static func encodeModelFB<T: Encodable>(_ model: T) throws -> [String: Any] {
        return try Firestore.Encoder().encode(model)
    }

    static func decodeModelFB<T: Decodable>(data: Any, forModel model: T.Type) throws -> T {
        return try Firestore.Decoder().decode(T.self, from: data)
    }
}
