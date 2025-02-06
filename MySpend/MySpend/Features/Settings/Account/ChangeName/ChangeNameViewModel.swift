//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

class ChangeNameViewModel: BaseViewModel {
    
    @Published var model = ChangeName()
    
    func changeUserName() async {
        if model.newUserName.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpace.localizedDescription
            return
        }
        
        await performWithLoader {
            do {
                try await AuthFB().updateUser(newUserName: self.model.newUserName)
                
                self.errorMessage = "Name updated"
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onAppear() {
        performWithCurrentUser { currentUser in
            self.model.userName = currentUser.displayName ?? ""
        }
    }
}
