//
//  ChangePasswordViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

class ChangePasswordViewModel: BaseViewModel {
    
    @Published var model = ChangePassword()
    
    func validateChangePassword() async {
        
        if model.userPassword.isEmptyOrWhitespace() || model.userNewPassword.isEmptyOrWhitespace()
            || model.userNewPasswordConfirm.isEmptyOrWhitespace() {
            model.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        if model.userNewPassword != model.userNewPasswordConfirm {
            model.errorMessage = ConstantMessages.newPasswordIsDifferent.localizedDescription
            return
        }
        
        await performWithLoader {
            do {
                try await AuthFB().updatePassword(actualPassword: self.model.userPassword,
                                                      newPasword: self.model.userNewPasswordConfirm)
                
                self.model.errorMessage = "PASSWORD CHANGED!"
            } catch {
                self.model.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onAppear() {
        if Auth.auth().currentUser == nil {
            model.disabled = true
            model.errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
        }
    }
}
