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
    
    enum Field: Hashable, CaseIterable {
        case userPassword
        case newPassword
        case newPasswordConfirm
    }
}
