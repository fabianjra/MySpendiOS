//
//  OnBoardingAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 7/7/25.
//

import Observation

@Observable
final class OnBoardingAccountViewModel {
    
    var accountName = ""
    var toastResponse: ToastResponse?
    
    func finishOnBoarding(withAccountName: Bool, accountManager: AccountManager) async {
        if withAccountName {
            if accountName.isEmptyOrWhitespace {
                toastResponse = ToastResponse(.responseErrorTextFieldEmptySpace, .error)
                return
            }
        } else {
            accountName = CDConstants.mainAccountName
        }
        
        let account = AccountModel(icon: ConstantSystemImage.bankDollarFill, name: accountName)
        toastResponse = await accountManager.create(account, isDefault: true)
        
        if toastResponse?.type == .ok {
            UserDefaultsManager.isOnBoarding = false
            Router.shared.reset()
        }
    }
}
