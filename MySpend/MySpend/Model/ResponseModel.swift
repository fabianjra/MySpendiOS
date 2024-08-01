//
//  ResponseModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 31/7/24.
//

struct ResponseModel {
    let code: Int
    let message: String
    
    init(_ code: Int = ConstantCodeResponse.ok, _ message: String = ConstantMessages.ok.localizedDescription) {
        self.code = code
        self.message = message
    }
}
