//
//  ValidateAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

class ValidateAccountViewModel: BaseViewModel {
    
    @Published var userIsValidated: Bool = false
    @Published var disabled: Bool = false
    
    private func getCurrentUser() -> User? {
        guard let currentUser = AuthFB().currentUser else {
            disabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return nil
        }
        
        return currentUser
    }
    
    func sendEmail() async {
        guard let currentUser = getCurrentUser() else {
            return
        }
        
        await performWithLoader {
            do {
                try await currentUser.reload()
                
                if !currentUser.isEmailVerified {
                    try await AuthFB().sendEmailRegisteredUser()
                    self.errorMessage = ConstantMessages.emailSent.localizedDescription
                } else {
                    self.errorMessage = ConstantMessages.userIsValidated.localizedDescription
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    //@discardableResult: Avoid the warning Xcode gives us when you dont use the return value, because this function is called in the OnAppear View without using the result.
    //@discardableResult
    func isUserValidated() async {
        guard let currentUser = getCurrentUser() else {
            return
        }
        
        await performWithLoader {
            do {
                try await currentUser.reload()
            } catch {
                self.errorMessage = error.localizedDescription
                self.disabled = true
            }
        }
        
        if currentUser.isEmailVerified {
            userIsValidated = true
            errorMessage = ConstantMessages.userIsValidated.localizedDescription
        }
    }
}
