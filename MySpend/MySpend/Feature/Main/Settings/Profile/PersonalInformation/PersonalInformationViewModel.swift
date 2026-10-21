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
    
    func changeUserName() -> ToastResponse {
        if username.isEmptyOrWhitespace {
            return ToastResponse(.responseErrorTextFieldEmptySpace, .error)
        }
        
        UserDefaultsManager.userName = username
        UserDefaultsManager.userEmail = email
        UserDefaultsManager.userPhone = phoneNumber
        
        return ToastResponse(.personalInformationMessageUpdated, .ok)
    }
    
    func loadData() {
        username = UserDefaultsManager.userName
        email = UserDefaultsManager.userEmail
        phoneNumber = UserDefaultsManager.userPhone
    }
}
