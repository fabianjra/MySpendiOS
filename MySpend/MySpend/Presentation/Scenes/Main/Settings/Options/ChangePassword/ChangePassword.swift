//
//  ChangePassword.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

struct ChangePassword {
    var userPassword: String = ""
    var userNewPassword: String = ""
    var userNewPasswordConfirm: String = ""
    
    var errorMessage: String = ""
    
    var disabled: Bool = false
    
    enum Field: Hashable {
        case userPassword
        case newPassword
        case newPasswordConfirm
    }
}
