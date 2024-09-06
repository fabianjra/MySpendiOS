//
//  ValidateAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

class ValidateAccountViewModel: BaseViewModel {
    
    @Published var userIsValidated: Bool = false
    var disabled: Bool = false
    
    func sendEmail() async {
        await performWithLoader {
            do {
                try await AuthFB().currentUser?.reload()
                
                if AuthFB().currentUser!.isEmailVerified == false {
                    try await AuthFB().sendEmailRegisteredUser()
                } else {
                    self.errorMessage = ConstantMessages.userIsValidated.localizedDescription
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    //@discardableResult: Avoid the warning Xcode gives us when you dont use the return value, because this function is called in the OnAppear View without using the result.
    @discardableResult
    func isUserValidated() async -> Bool {
        
        await performWithLoader {
            do {
                try await AuthFB().currentUser?.reload() //TODO: Esto es un parche.
                self.errorMessage = ConstantMessages.emailSent.localizedDescription
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }

        if AuthFB().currentUser != nil {
            
            if AuthFB().currentUser!.isEmailVerified {
                userIsValidated = true
                disabled = true
                errorMessage = ConstantMessages.userIsValidated.localizedDescription
                return true
                
            } else {
                return false
            }
            
        } else {
            disabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return false
        }
    }
}
