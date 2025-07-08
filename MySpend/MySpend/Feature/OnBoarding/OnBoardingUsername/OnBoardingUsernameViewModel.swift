//
//  OnBoardingViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Foundation

class OnBoardingUsernameViewModel: BaseViewModel {
    
    @Published var userName = ""
    
    func continueWithUserName() {
        if userName.isEmptyOrWhitespace {
            errorMessage = Errors.emptySpace.localizedDescription
            return
        }
        
        UserDefaultsManager.userName = userName
        UserDefaultsManager.isOnBoarding = false
    }
    
    func continueWithoutUserName() {
        UserDefaultsManager.isOnBoarding = false
    }
    
    enum Field: Hashable, CaseIterable {
        case userName
    }
}
