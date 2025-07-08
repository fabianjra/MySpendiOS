//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Firebase

final class ChangeNameViewModel: BaseViewModel {
    
    @Published var model = ChangeName()
    
    func changeUserName() {
        if model.newUsername.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpace.localizedDescription
            return
        }
        
        UserDefaultsManager.userName = model.newUsername
        model.username = model.newUsername
        model.newUsername = ""
    }
    
    func onAppear() {
        model.username = UserDefaultsManager.userName
    }
}
