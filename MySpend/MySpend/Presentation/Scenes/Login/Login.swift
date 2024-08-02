//
//  LoginModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Login {
    var email: String = ""
    var isEmailError: Bool = false

    var password: String = ""
    var isPasswordError: Bool = false

    var errorMessage: String = ""
    var canSubmit: Bool = false
    var navigateToRegisterView: Bool = false

    var isLoading: Bool = false
    
    /// Used for @FocusState in the Login View.
    enum Field: Hashable {
        case email
        case password
    }
}
