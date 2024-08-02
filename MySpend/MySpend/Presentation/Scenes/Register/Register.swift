//
//  Register.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

struct Register {
    let userName: String = ""
    let isUserNameError: Bool = false
    
    let userEmail: String = ""
    let isUserEmailError: Bool = false
    
    let userPassword: String = ""
    let isUserPasswordError: Bool = false
    
    let userPasswordConfirm: String = ""
    let isUserPasswordConfirmError: Bool = false
    
    let errorMessage: String = ""
    let canSubmit: Bool = false
    
    let errorUpdateName: String = ""
    let errorSendEmail: String = ""
    
    let isLoading: Bool = false
}
