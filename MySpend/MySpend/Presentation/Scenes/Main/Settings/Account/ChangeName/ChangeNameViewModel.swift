//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

class ChangeNameViewModel: BaseViewModel {

    @Published var model = ChangeName()
    @Published var disabled: Bool = false
    
    private func getCurrentUser() -> User? {
        guard let currentUser = AuthFB().currentUser else {
            disabled = true
            errorMessage = ConstantMessages.userNotLoggedIn.localizedDescription
            return nil
        }
        
        return currentUser
    }
    
    func changeUserName() async {
        if model.newUserName.isEmptyOrWhitespace() {
            errorMessage = ConstantMessages.emptySpace.localizedDescription
            return
        }
        
        guard let currentUser = getCurrentUser() else {
            return
        }
        
        await performWithLoader {
            do {
                try await AuthFB().updateUser(newUserName: self.model.newUserName, forUser: currentUser)
                
                self.errorMessage = "Name changed to: \(currentUser.displayName ?? "")"
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onAppear() {
        guard let currentUser = getCurrentUser() else {
            return
        }
        
        model.userName = currentUser.displayName ?? ""
    }
}
