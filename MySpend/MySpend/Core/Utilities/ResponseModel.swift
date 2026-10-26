//
//  ResponseModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/24.
//

//TODO: ELIMINAR cuando se migre AddModifyTransaction
struct ResponseModel {
    let status: Status
    let message: String
    
    init(_ status: Status = .successful,
         _ message: String = Errors.successful.localizedDescription) {
        self.status = status
        self.message = message
    }
}

enum Status {
    case successful
    case error
    
    var isSuccess: Bool {
        self == .successful
    }
    
    var isError: Bool {
        self == .error
    }
}
