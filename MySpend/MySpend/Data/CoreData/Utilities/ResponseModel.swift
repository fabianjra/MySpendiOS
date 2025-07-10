//
//  ResponseModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/24.
//

struct ResponseModel {
    let status: Status
    let message: String
    
    init(_ status: Status = .successful,
         _ message: String = Errors.successful.localizedDescription) {
        self.status = status
        self.message = message
    }
}
