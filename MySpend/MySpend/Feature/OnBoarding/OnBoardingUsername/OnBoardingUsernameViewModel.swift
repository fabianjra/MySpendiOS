//
//  OnBoardingViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Observation

@Observable
final class OnBoardingUsernameViewModel {
    
    var userName = ""
    var toastResponse: ToastResponse?
    
    func continueToNextStep(withName: Bool) {
        if withName {
            if userName.isEmptyOrWhitespace {
                toastResponse = ToastResponse(.responseErrorTextFieldEmptySpace, .error)
                return
            }
            
            UserDefaultsManager.userName = userName
        }
        
        Router.shared.navigate(to: .onBoardinAccount)
    }
}
