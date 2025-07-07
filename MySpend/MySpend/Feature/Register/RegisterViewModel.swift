//
//  RegisterViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class RegisterViewModel: BaseViewModelFB {
    
    @Published var register = Register()
    
    func validateRegister() async -> ResponseModelFB {
        if register.name.isEmptyOrWhitespace || register.email.isEmptyOrWhitespace ||
            register.password.isEmptyOrWhitespace || register.passwordConfirm.isEmptyOrWhitespace {
            
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        if register.password.count < ConstantViews.passwordMinimumLength || register.passwordConfirm.count < ConstantViews.passwordMinimumLength {
            return ResponseModelFB(.error, Errors.passwordIsShort.localizedDescription)
        }
        
        if register.password != register.passwordConfirm {
            return ResponseModelFB(.error, Errors.creationPasswordIsDifferent.localizedDescription)
        }
        
        var response = ResponseModelFB()
        
        await performWithLoader {
            do {
                try await AuthFB().registerUser(withEmail: self.register.email,
                                                password: self.register.password,
                                                username: self.register.name)
                response = ResponseModelFB(.successful)
            } catch {
                Logs.CatchException(error)
                response = ResponseModelFB(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
