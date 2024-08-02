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
        login.isUserEmailError = login.userEmail.isEmptyOrWhitespace()
        login.isUserPasswordError = login.userPassword.isEmptyOrWhitespace()
        
        if login.isUserEmailError || login.isUserPasswordError {
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
        
        try await SessionStore.singIn(login.userEmail, password: login.userPassword)
        login.canSubmit = true
    }
}
