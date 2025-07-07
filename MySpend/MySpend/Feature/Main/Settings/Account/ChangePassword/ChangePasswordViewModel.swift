//
//  ChangePasswordViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

class ChangePasswordViewModel: BaseViewModelFB {
    
    @Published var model = ChangePassword()
    
    func validateChangePassword() async {
        
        if model.userPassword.isEmptyOrWhitespace || model.userNewPassword.isEmptyOrWhitespace
            || model.userNewPasswordConfirm.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpaces.localizedDescription
            return
        }
        
        if model.userNewPassword != model.userNewPasswordConfirm {
            errorMessage = Errors.newPasswordIsDifferent.localizedDescription
            return
        }
        
        await performWithLoader {
            do {
                try await AuthFB().updatePassword(actualPassword: self.model.userPassword,
                                                      newPasword: self.model.userNewPasswordConfirm)
                
                self.errorMessage = "Password changed"
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
