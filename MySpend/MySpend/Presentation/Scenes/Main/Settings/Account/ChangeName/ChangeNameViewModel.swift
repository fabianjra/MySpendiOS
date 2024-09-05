//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Combine

class ChangeNameViewModel: BaseViewModel {

    @Published var model = ChangeName()
    let currentUser = AuthFB().currentUser
    
    var errorMessage: String = ""
    @Published var disabled: Bool = false
    
    func changeUserName() async {
        
        if model.newUserName.isEmptyOrWhitespace() {
            errorMessage = ConstantMessages.emptySpace.localizedDescription
            return
        }
        
        await performWithLoader {
            do {
                try await AuthFB().updateUser(newUserName: self.model.newUserName, forUser: self.currentUser)
                
                self.errorMessage = "NAME CHANGED TO: \(self.currentUser?.displayName ?? "")"
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onAppear() {
        model.userName = currentUser?.displayName ?? ""
        
        if let currentUser = currentUser?.displayName {
            model.userName = currentUser
        } else {
            disabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
        }
    }
}
