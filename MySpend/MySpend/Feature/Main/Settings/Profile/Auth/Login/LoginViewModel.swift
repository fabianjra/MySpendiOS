//
//  LoginViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 2/8/24.
//

import SwiftUI

class LoginViewModel: BaseViewModel {
    
    @Published var login = Login()
    
    func validateLogin() async {
        if login.email.isEmptyOrWhitespace || login.password.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpaces.localizedDescription
            return
        }
        
//        await performWithLoader {
//            do {
//                try await AuthFB().singIn(self.login.email, password: self.login.password)
//            } catch {
//                Logger.exception(error)
//                self.errorMessage = error.localizedDescription
//            }
//        }
    }
}
