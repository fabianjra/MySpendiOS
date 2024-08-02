//
//  Register.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Register {
    var userName: String = ""
    var isUserNameError: Bool = false
    
    var userEmail: String = ""
    var isUserEmailError: Bool = false
    
    var userPassword: String = ""
    var isUserPasswordError: Bool = false
    
    var userPasswordConfirm: String = ""
    var isUserPasswordConfirmError: Bool = false
    
    var errorMessage: String = ""
    var canSubmit: Bool = false
    
    var errorUpdateName: String = ""
    var errorSendEmail: String = ""
    
    var isLoading: Bool = false
    
    enum Field: Hashable {
        case name
        case email
        case password
        case passwordConfirm
    }
}
