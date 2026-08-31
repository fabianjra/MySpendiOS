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
    
    var showToast: Bool = false
    var responseToast = ResponseToast() {
        didSet {
            showToast = true
        }
    }
    
    func changeUserName() {
        if username.isEmptyOrWhitespace {
            responseToast = ResponseToast(.responseErrorTextFieldEmptySpace, .error)
            return
        }
        
        UserDefaultsManager.userName = username
        UserDefaultsManager.userEmail = email
        UserDefaultsManager.userPhone = phoneNumber
        
        responseToast = ResponseToast(.personalInformationMessageUpdated, .ok)
    }
    
    func loadData() {
        username = UserDefaultsManager.userName
        email = UserDefaultsManager.userEmail
        phoneNumber = UserDefaultsManager.userPhone
    }
}
