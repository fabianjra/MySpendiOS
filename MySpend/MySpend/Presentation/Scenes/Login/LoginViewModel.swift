//
//  LoginViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import Combine

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var login = Login()
    
    func validateLogin() async {
        //If Textfields are empty, bool error will be true.
        login.isEmailError = login.email.isEmptyOrWhitespace()
        login.isPasswordError = login.password.isEmptyOrWhitespace()
        
        if login.isEmailError || login.isPasswordError {
            login.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        do {
            try await login()
        } catch {
            Logs.WriteCatchExeption(error: error)
            login.errorMessage = error.localizedDescription
        }
    }
    
    func login() async throws {
        login.isLoading = true
        
        defer {
            login.isLoading = false
        }
        
        try await SessionStore.singIn(login.email, password: login.password)
        login.canSubmit = true
    }
}
