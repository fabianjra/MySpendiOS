//
//  UtilsFirebase.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/24.
//
import Firebase

struct UtilsStore {
    
    static let db = Firestore.firestore()
    static let userCollectionReference = db.collection(ConstantFB.Collections.users)

    static func encodeModelFB<T: Encodable>(_ model: T) throws -> [String: Any] {
        return try Firestore.Encoder().encode(model)
    }

    static func decodeModelFB<T: Decodable>(data: Any, forModel model: T.Type) throws -> T {
        return try Firestore.Decoder().decode(T.self, from: data)
    }
}
