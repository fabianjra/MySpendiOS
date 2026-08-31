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
    var errorMessage = ""
    
    func changeUserName() {
        if username.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpace.localizedDescription
            return
        }
        
        UserDefaultsManager.userName = username
    }
    
    func onAppear() {
        username = UserDefaultsManager.userName
    }
}
