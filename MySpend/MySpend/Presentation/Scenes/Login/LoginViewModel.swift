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
        login.errorMessage = ""
        
        if login.email.isEmptyOrWhitespace() || login.password.isEmptyOrWhitespace() {
            login.errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        login.isLoading = true
        
        defer {
            login.isLoading = false
        }
        
        do {
            try await SessionStore.singIn(login.email, password: login.password)
        } catch {
            Logs.WriteCatchExeption(error: error)
            login.errorMessage = error.localizedDescription
        }
    }
}
