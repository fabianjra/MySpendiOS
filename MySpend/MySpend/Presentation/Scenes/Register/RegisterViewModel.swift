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
        
        if register.name.isEmptyOrWhitespace() || register.email.isEmptyOrWhitespace() ||
            register.password.isEmptyOrWhitespace() || register.passwordConfirm.isEmptyOrWhitespace() {
            register.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        if register.password.count < 6 || register.passwordConfirm.count < 6 {
            register.errorMessage = ConstantMessages.passwordIsShort.localizedDescription
            return
        }
        
        if register.password != register.passwordConfirm {
            register.errorMessage = ConstantMessages.creationPasswordIsDifferent.localizedDescription
            return
        }
        
        register.isLoading = true
        
        defer {
            register.isLoading = false
        }
        
        do {
            try await SessionStore.registerUser(withEmail: register.email,
                                                password: register.password,
                                                username: register.name)
            register.canSubmit = true
        } catch {
            Logs.WriteCatchExeption(error: error)
            register.errorMessage = error.localizedDescription
        }
    }
}
