//
//  RegisterViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Foundation

class RegisterViewModel: BaseViewModel {
    
    @Published var register = Register()
    
    func validateRegister() async -> ResponseModel {
        if register.name.isEmptyOrWhitespace || register.email.isEmptyOrWhitespace ||
            register.password.isEmptyOrWhitespace || register.passwordConfirm.isEmptyOrWhitespace {
            
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        if register.password.count < ConstantViews.passwordMinimumLength || register.passwordConfirm.count < ConstantViews.passwordMinimumLength {
            return ResponseModel(.error, Errors.passwordIsShort.localizedDescription)
        }
        
        if register.password != register.passwordConfirm {
            return ResponseModel(.error, Errors.creationPasswordIsDifferent.localizedDescription)
        }
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await AuthFB().registerUser(withEmail: self.register.email,
                                                password: self.register.password,
                                                username: self.register.name)
                response = ResponseModel(.successful)
            } catch {
                Logs.CatchException(error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
