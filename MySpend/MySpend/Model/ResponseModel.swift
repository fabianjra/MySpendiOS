//
//  ResponseModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/24.
//

enum Status {
    case successful
    case error
    
    var isSuccess: Bool {
        switch self {
        case .successful:
            return true
        case .error:
            return false
        }
    }
}

struct ResponseModel {
    let status: Status
    let message: String
    
    init(_ status: Status = .successful, _ message: String = Messages.successful.localizedDescription) {
        self.status = status
        self.message = message
    }
}
