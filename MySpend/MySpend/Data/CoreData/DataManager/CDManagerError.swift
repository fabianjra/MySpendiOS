//
//  ResponseModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/6/25.
//

import Foundation

struct CDManagerError {
    let status: Status
    let message: String
    
    init(_ status: Status = .successful, _ message: String = Errors.successful.localizedDescription) {
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
