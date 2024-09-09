//
//  LoginModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Login {
    var email: String = ""
    var password: String = ""
    
    /// Used for @FocusState in the Login View.
    enum Field: Hashable, CaseIterable {
        case email
        case password
    }
}
