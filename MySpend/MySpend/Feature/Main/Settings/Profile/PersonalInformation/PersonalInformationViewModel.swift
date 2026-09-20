//
//  ChangeNameViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

@Observable
final class PersonalInformationViewModel {
    
    var username = ""
    var email = ""
    var phoneNumber = ""
    
    func changeUserName() -> ResponseToast {
        if username.isEmptyOrWhitespace {
            return ResponseToast(.responseErrorTextFieldEmptySpace, .error)
        }
        
        UserDefaultsManager.userName = username
        UserDefaultsManager.userEmail = email
        UserDefaultsManager.userPhone = phoneNumber
        
        return ResponseToast(.personalInformationMessageUpdated, .ok)
    }
    
    func loadData() {
        username = UserDefaultsManager.userName
        email = UserDefaultsManager.userEmail
        phoneNumber = UserDefaultsManager.userPhone
    }
}
