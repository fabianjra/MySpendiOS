//
//  Register.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Register {
    var name: String = ""
    var isNameError: Bool = false
    
    var email: String = ""
    var isEmailError: Bool = false
    
    var password: String = ""
    var isPasswordError: Bool = false
    
    var passwordConfirm: String = ""
    var isPasswordConfirmError: Bool = false
    
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
