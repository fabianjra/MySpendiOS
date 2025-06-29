//
//  ResponseModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/24.
//

import Firebase

struct ResponseModelFB {
    let status: Status
    let message: String
    let documentReference: DocumentReference?
    
    init(_ status: Status = .successful,
         _ message: String = Errors.successful.localizedDescription,
         document documentReference: DocumentReference? = nil) {
        self.status = status
        self.message = message
        self.documentReference = documentReference
    }
}
