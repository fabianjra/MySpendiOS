//
//  Register.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Register {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirm: String = ""
    
    enum Field: Hashable, CaseIterable {
        case name
        case email
        case password
        case passwordConfirm
    }
}
