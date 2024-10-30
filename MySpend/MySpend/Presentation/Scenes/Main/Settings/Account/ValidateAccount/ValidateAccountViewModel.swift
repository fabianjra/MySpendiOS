//
//  ValidateAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

class ValidateAccountViewModel: BaseViewModel {
    
    @Published var userIsValidated: Bool = false
    
    func sendEmail() async {
        await performWithLoader { currentUser in
            do {
                try await currentUser.reload()
                
                if !currentUser.isEmailVerified {
                    
                    try await AuthFB().sendEmailRegisteredUser()
                    
                    self.errorMessage = Errors.emailSent.localizedDescription
                } else {
                    self.errorMessage = Errors.userIsValidated.localizedDescription
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    //@discardableResult: Avoid the warning Xcode gives us when you dont use the return value, because this function is called in the OnAppear View without using the result.
    //@discardableResult
    func onAppear() async {
        await performWithLoader { currentUser in
            do {
                try await currentUser.reload()
                
                if currentUser.isEmailVerified {
                    self.userIsValidated = true
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.disabled = true
            }
        }
    }
}
