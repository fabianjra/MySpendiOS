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
    
    var errorMessage: String = ""
    
    var canSubmit: Bool = false
    var isLoading: Bool = false
    
    enum Field: Hashable {
        case name
        case email
        case password
        case passwordConfirm
    }
}
