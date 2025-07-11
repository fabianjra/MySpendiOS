//
//  OnBoardingViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Foundation

class OnBoardingUsernameViewModel: BaseViewModel {
    
    @Published var userName = ""
    
    func continueToNextStep(withName: Bool) {
        if withName {
            if userName.isEmptyOrWhitespace {
                errorMessage = Errors.emptySpace.localizedDescription
                return
            }
        }
        
        UserDefaultsManager.userName = userName
        
        Router.shared.path.append(Router.Destination.onBoardinAccount)
    }
    
    enum Field: Hashable, CaseIterable {
        case userName
    }
}
