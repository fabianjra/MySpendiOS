//
//  LoginViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import SwiftUI

class LoginViewModel: BaseViewModel {
    
    @Published var login = Login()
    
    var errorMessage: String = ""
    
    func validateLogin() async {
        errorMessage = ""
        
        if login.email.isEmptyOrWhitespace() || login.password.isEmptyOrWhitespace() {
            errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return
        }
        
        await performWithLoader {
            do {
                try await AuthFB().singIn(self.login.email, password: self.login.password)
            } catch {
                Logs.WriteCatchExeption(error: error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
