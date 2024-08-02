//
//  LoginModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Login {
    var userEmail: String = ""
    var isUserEmailError: Bool = false

    var userPassword: String = ""
    var isUserPasswordError: Bool = false

    var errorMessage: String = ""
    var canSubmit: Bool = false
    var goToRegister: Bool = false

    var isLoading: Bool = false
    
    /// Used for @FocusState in the Login View.
    enum Field: Hashable {
        case email
        case password
    }
}
