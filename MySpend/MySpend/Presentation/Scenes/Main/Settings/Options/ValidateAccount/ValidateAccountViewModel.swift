//
//  ValidateAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

class ValidateAccountViewModel: BaseViewModel {
    
    @Published var model = ValidateAccount()
    
    func sendEmail() async {
        
        do {
            if isUserValidated() == false {
                try await SessionStore.sendEmailRegisteredUser()
            }
        }
        catch {
            model.errorMessage = error.localizedDescription
        }
    }
    
    //@discardableResult: Avoid the warning Xcode gives us when you dont use the return value, because this function is called in the OnAppear View without using the result.
    @discardableResult
    func isUserValidated() -> Bool {
        
        UtilsStore.getCurrentUser()?.reload() //TODO: Esto es un parche.

        if let user = UtilsStore.getCurrentUser() {
            
            if user.isEmailVerified {
                model.userIsValidated = true
                model.disabled = true
                model.errorMessage = ConstantMessages.userIsValidated.localizedDescription
                return true
                
            } else {
                return false
            }
            
        } else {
            model.disabled = true
            model.errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return false
        }
    }
}
