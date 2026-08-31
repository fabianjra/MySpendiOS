//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Observation

@Observable
final class PersonalInformationViewModel {
    
    var username = ""
    var newUsername = ""
    var errorMessage = ""
    
    func changeUserName() {
        if newUsername.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpace.localizedDescription
            return
        }
        
        UserDefaultsManager.userName = newUsername
        username = newUsername
        newUsername = ""
    }
    
    func onAppear() {
        username = UserDefaultsManager.userName
    }
}
