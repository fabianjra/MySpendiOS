//
//  LoginModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Login {
    var email: String = ""
    var password: String = ""

    var errorMessage: String = ""
    
    var isLoading: Bool = false
    
    /// Used for @FocusState in the Login View.
    enum Field: Hashable {
        case email
        case password
    }
}
