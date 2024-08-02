//
//  RegisterViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Combine

@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var register = Register()
    
    func validateRegister() async {
        register.isUserNameError = register.userName.isEmptyOrWhitespace()
        register.isUserEmailError = register.userEmail.isEmptyOrWhitespace()
        register.isUserPasswordError = register.userPassword.isEmptyOrWhitespace()
        register.isUserPasswordConfirmError = register.userPasswordConfirm.isEmptyOrWhitespace()
        
        if register.isUserNameError || register.isUserEmailError ||
            register.isUserPasswordError || register.isUserPasswordConfirmError {
            register.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        if register.userPassword.count < 6 || register.userPasswordConfirm.count < 6 {
            register.errorMessage = ConstantMessages.passwordIsShort.localizedDescription
            return
        }
        
        if register.userPassword != register.userPasswordConfirm {
            register.errorMessage = ConstantMessages.creationPasswordIsDifferent.localizedDescription
            return
        }
        
        register.isLoading = true
        
        do {
            defer {
                register.isLoading = false
            }
            
            try await SessionStore.registerUser(withEmail: register.userEmail,
                                                password: register.userPassword,
                                                username: register.userName)
            
            register.canSubmit = true
        } catch {
            register.errorMessage = error.localizedDescription
        }
    }
}
